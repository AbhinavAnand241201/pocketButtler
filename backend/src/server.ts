import 'dotenv/config';
import http from 'http';
import express from 'express';
import mongoose, { ConnectOptions } from 'mongoose';
import cors from 'cors';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import cookieParser from 'cookie-parser';
// Graceful shutdown setup
import logger from './utils/logger';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import apiRoutes from './routes/api';

// Environment variables type definition
declare global {
  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production' | 'test';
      PORT: string;
      MONGODB_URI: string;
      JWT_SECRET: string;
      JWT_EXPIRES_IN: string;
      JWT_REFRESH_EXPIRES_IN: string;
      ALLOWED_ORIGINS?: string;
      RATE_LIMIT_WINDOW_MS?: string;
      RATE_LIMIT_MAX?: string;
    }
  }
}

// Import socket service if needed
// import { initializeSocket } from './services/socket.service';

// Validate required environment variables
const requiredEnvVars = ['JWT_SECRET', 'JWT_EXPIRES_IN', 'JWT_REFRESH_EXPIRES_IN'];
const missingEnvVars = requiredEnvVars.filter(envVar => !process.env[envVar]);

if (missingEnvVars.length > 0) {
  logger.error(`Missing required environment variables: ${missingEnvVars.join(', ')}`);
  process.exit(1);
}

// Load environment variables with defaults
const PORT = parseInt(process.env.PORT || '3000', 10);
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/pocket-butler';

// Validate MONGODB_URI format
if (!MONGODB_URI.startsWith('mongodb://') && !MONGODB_URI.startsWith('mongodb+srv://')) {
  logger.error('Invalid MONGODB_URI format. It must start with mongodb:// or mongodb+srv://');
  process.exit(1);
}

// Initialize Express app
const app = express();
const server = http.createServer(app);

// Initialize Socket.IO if needed
// initializeSocket(server);

// Middleware
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : '*',
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// Logging
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000'), // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX || '100'), // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
});
app.use(limiter);

// API Routes
app.use('/api', apiRoutes);

// Health check endpoint (handled by apiRoutes)
// 404 handler for non-API routes
app.use(notFoundHandler);

// Global error handler - must be the last middleware
app.use(errorHandler);

/**
 * Database connection
 */
const connectDB = async (): Promise<void> => {
  try {
    const options: mongoose.ConnectOptions = {
      // These options are no longer needed in Mongoose 6+
      // but keeping them for backward compatibility
      // @ts-ignore
      useNewUrlParser: true,
      // @ts-ignore
      useUnifiedTopology: true,
      // Better connection pooling
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    };

    await mongoose.connect(MONGODB_URI, options);
    
    logger.info('MongoDB connected successfully');
  } catch (error) {
    logger.error('MongoDB connection error:', error);
    // In case of connection error, wait 5 seconds before retrying
    await new Promise(resolve => setTimeout(resolve, 5000));
    process.exit(1);
  }
};

/**
 * Graceful shutdown handler
 */
const onSignal = async (): Promise<void> => {
  logger.info('Server is starting cleanup');
  
  try {
    // Close MongoDB connection
    if (mongoose.connection.readyState === 1) { // 1 = connected
      await mongoose.connection.close();
      logger.info('MongoDB connection closed');
    }
    
    // Add other cleanup tasks here (e.g., close Redis connections, etc.)
  } catch (error) {
    logger.error('Error during cleanup:', error);
    // Don't throw here to allow the process to exit
  }
};

/**
 * Shutdown handler
 */
const onShutdown = (): void => {
  logger.info('Cleanup finished, server is shutting down');
};

/**
 * Health check function
 */
const onHealthCheck = async (): Promise<{ status: string }> => {
  const checks = {
    database: mongoose.connection.readyState === 1,
    // Add other health checks here
  };
  
  const isHealthy = Object.values(checks).every(Boolean);
  
  if (!isHealthy) {
    const failedChecks = Object.entries(checks)
      .filter(([_, value]) => !value)
      .map(([key]) => key);
      
    logger.error(`Health check failed for: ${failedChecks.join(', ')}`);
    throw new Error(`Service unhealthy: ${failedChecks.join(', ')}`);
  }
  
  return { status: 'ok' };
};

/**
 * Start the server
 */
const startServer = async (): Promise<void> => {
  try {
    // Connect to database
    await connectDB();
    
    // Set up graceful shutdown
    const gracefulShutdown = async (signal: string) => {
      logger.info(`Received ${signal}. Starting graceful shutdown...`);
      
      try {
        // Close the server first to stop accepting new connections
        await new Promise<void>((resolve, reject) => {
          server.close((err) => {
            if (err) {
              reject(err);
            } else {
              resolve();
            }
          });
        });
        
        // Run cleanup tasks
        await onSignal();
        onShutdown();
        
        logger.info('Graceful shutdown completed');
        process.exit(0);
      } catch (error) {
        logger.error('Error during graceful shutdown:', error);
        process.exit(1);
      }
    };
    
    // Handle signals
    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));
    
    // Health check endpoint
    app.get('/health', async (req, res) => {
      try {
        const health = await onHealthCheck();
        res.status(200).json(health);
      } catch (error) {
        res.status(503).json({ status: 'error', error: 'Service Unavailable' });
      }
    });

    // Start listening
    await new Promise<void>((resolve, reject) => {
      server.listen(PORT, () => {
        logger.info(`Server running on port ${PORT} in ${process.env.NODE_ENV} mode`);
        logger.info(`Allowed origins: ${process.env.ALLOWED_ORIGINS || '*'}`);
        resolve();
      }).on('error', reject);
    });
    
    // Handle uncaught exceptions
    process.on('uncaughtException', (error: Error) => {
      logger.error('Uncaught Exception:', error);
      // Consider whether to exit here based on the error
      // process.exit(1);
    });
    
  } catch (error) {
    logger.error('Failed to start server:', error);
    // Give time for logs to be written before exiting
    setTimeout(() => process.exit(1), 1000);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason: unknown) => {
  logger.error('Unhandled Rejection:', reason);
  // Consider whether to exit here based on the error
  // server.close(() => process.exit(1));
});

// Start the server
startServer();

export default app;
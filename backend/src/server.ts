import 'dotenv/config';
import http from 'http';
import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import cookieParser from 'cookie-parser';
import { createTerminus } from '@godaddy/terminus';
import logger from './utils/logger';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import apiRoutes from './routes/api';

// Import socket service if needed
// import { initializeSocket } from './services/socket.service';

// Load environment variables
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/pocket-butler';

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

// Database connection
const connectDB = async (): Promise<void> => {
  try {
    await mongoose.connect(MONGODB_URI, {
      // @ts-ignore - these options are valid but not in the type definitions
      useNewUrlParser: true,
      useUnifiedTopology: true,
    } as mongoose.ConnectOptions);
    
    logger.info('MongoDB connected successfully');
  } catch (error) {
    logger.error(`MongoDB connection error: ${error}`);
    process.exit(1);
  }
};

// Graceful shutdown
const onSignal = async (): Promise<void> => {
  logger.info('Server is starting cleanup');
  await mongoose.connection.close();
  logger.info('MongoDB connection closed');
};

const onShutdown = (): void => {
  logger.info('Cleanup finished, server is shutting down');
};

const startServer = async (): Promise<void> => {
  try {
    await connectDB();
    
    createTerminus(server, {
      signal: 'SIGINT',
      healthChecks: { '/health': onHealthCheck },
      onSignal,
      onShutdown,
      logger: (msg: string, err: Error) => {
        logger.error(msg, { error: err });
      }
    });

    server.listen(PORT, () => {
      logger.info(`Server running on port ${PORT} in ${process.env.NODE_ENV} mode`);
    });
  } catch (error) {
    logger.error(`Failed to start server: ${error}`);
    process.exit(1);
  }
};

const onHealthCheck = async (): Promise<{ status: string }> => {
  const checks = {
    database: mongoose.connection.readyState === 1
  };
  
  const isHealthy = Object.values(checks).every(Boolean);
  
  if (!isHealthy) {
    throw new Error('Service unhealthy');
  }
  
  return { status: 'ok' };
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err: Error) => {
  logger.error(`Unhandled Rejection: ${err.message}`, { error: err });
  // Close server & exit process
  server.close(() => process.exit(1));
});

// Start the server
startServer();

export default app;
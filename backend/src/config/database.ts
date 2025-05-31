import mongoose from 'mongoose';
import { logger } from '@utils/logger';

const connectDB = async (): Promise<void> => {
  try {
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/pocket-butler';
    
    if (!MONGODB_URI) {
      throw new Error('MongoDB connection string is not defined in environment variables');
    }

    const conn = await mongoose.connect(MONGODB_URI, {
      serverSelectionTimeoutMS: 5000, // Timeout after 5s instead of 30s
      socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
    });

    logger.info(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    logger.error(`MongoDB connection error: ${error}`);
    process.exit(1);
  }
};

export default connectDB;
import { Request, Response, NextFunction } from 'express';
import ApiResponseHandler from '../utils/response';
import logger from '../utils/logger';

class AppError extends Error {
  statusCode: number;
  status: string;
  isOperational: boolean;

  constructor(message: string, statusCode: number) {
    super(message);

    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// Error handling for development environment
const sendErrorDev = (err: any, res: Response) => {
  ApiResponseHandler.error(
    res,
    err.message,
    err.statusCode || 500,
    {
      status: err.status,
      error: err,
      stack: err.stack,
    }
  );
};

// Error handling for production environment
const sendErrorProd = (err: any, res: Response) => {
  // Operational, trusted error: send message to client
  if (err.isOperational) {
    ApiResponseHandler.error(
      res,
      err.message,
      err.statusCode || 500,
      {
        status: err.status,
        message: err.message,
      }
    );
  } else {
    // Programming or other unknown error: don't leak error details
    // 1) Log error
    logger.error('ERROR 💥', err);

    // 2) Send generic message
    ApiResponseHandler.error(
      res,
      'Something went very wrong!',
      500,
      {
        status: 'error',
        message: 'Please try again later.',
      }
    );
  }
};

// Handle specific database errors
const handleCastErrorDB = (err: any) => {
  const message = `Invalid ${err.path}: ${err.value}`;
  return new AppError(message, 400);
};

const handleDuplicateFieldsDB = (err: any) => {
  const value = err.errmsg.match(/(["'])(?:(?=(\\?))\2.)*?\1/)[0];
  const message = `Duplicate field value: ${value}. Please use another value!`;
  return new AppError(message, 400);
};

const handleValidationErrorDB = (err: any) => {
  const errors = Object.values(err.errors).map((el: any) => el.message);
  const message = `Invalid input data. ${errors.join('. ')}`;
  return new AppError(message, 400);
};

const handleJWTError = () =>
  new AppError('Invalid token. Please log in again!', 401);

const handleJWTExpiredError = () =>
  new AppError('Your token has expired! Please log in again.', 401);

// Global error handling middleware
export const errorHandler = (
  err: any,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || 'error';

  if (process.env.NODE_ENV === 'development') {
    sendErrorDev(err, res);
  } else if (process.env.NODE_ENV === 'production') {
    let error = { ...err };
    error.message = err.message;

    if (error.name === 'CastError') error = handleCastErrorDB(error);
    if (error.code === 11000) error = handleDuplicateFieldsDB(error);
    if (error.name === 'ValidationError')
      error = handleValidationErrorDB(error);
    if (error.name === 'JsonWebTokenError') error = handleJWTError();
    if (error.name === 'TokenExpiredError') error = handleJWTExpiredError();

    sendErrorProd(error, res);
  }
};

// 404 handler
export const notFoundHandler = (req: Request, res: Response) => {
  ApiResponseHandler.notFound(res, `Can't find ${req.originalUrl} on this server!`);
};

export default {
  AppError,
  errorHandler,
  notFoundHandler,
};
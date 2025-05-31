import { Response } from 'express';

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
    totalPages?: number;
  };
  // Additional details for development environment
  details?: any;
}

export class ApiResponseHandler {
  static success<T>(
    res: Response,
    data: T,
    message: string = 'Success',
    statusCode: number = 200,
    meta?: any
  ) {
    const response: ApiResponse<T> = {
      success: true,
      message,
      data,
    };

    if (meta) {
      response.meta = meta;
    }

    return res.status(statusCode).json(response);
  }

  static error(
    res: Response,
    error: string | Error,
    statusCode: number = 400,
    details?: any
  ) {
    const response: ApiResponse = {
      success: false,
      error: error instanceof Error ? error.message : error,
    };

    if (process.env.NODE_ENV === 'development' && details) {
      response['details'] = details;
    }

    return res.status(statusCode).json(response);
  }

  static notFound(res: Response, message: string = 'Resource not found') {
    return this.error(res, message, 404);
  }

  static unauthorized(res: Response, message: string = 'Not authorized') {
    return this.error(res, message, 401);
  }

  static forbidden(res: Response, message: string = 'Forbidden') {
    return this.error(res, message, 403);
  }

  static validationError(res: Response, errors: any[] = []) {
    return res.status(422).json({
      success: false,
      error: 'Validation failed',
      errors,
    });
  }

  static serverError(
    res: Response,
    error: Error,
    message: string = 'Internal server error'
  ) {
    console.error('Server Error:', error);
    return this.error(
      res,
      process.env.NODE_ENV === 'production' ? message : error.message,
      500
    );
  }
}

export default ApiResponseHandler;
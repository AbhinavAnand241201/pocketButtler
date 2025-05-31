import { Request, Response, NextFunction } from 'express';
import { verifyToken } from '../utils/jwt';
import { User } from '../models/User';
import { ErrorResponse } from '../types/auth.types';

export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    email: string;
  };
}

export const protect = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    let token: string | undefined;

    // Get token from header
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    } 
    // Get token from cookies if not in header
    else if (req.cookies?.token) {
      token = req.cookies.token;
    }

    if (!token) {
      const errorResponse: ErrorResponse = {
        success: false,
        error: 'Not authorized to access this route',
      };
      return res.status(401).json(errorResponse);
    }

    // Verify token
    const decoded = verifyToken(token);

    // Get user from the token
    const user = await User.findById(decoded.id).select('-password');

    if (!user) {
      const errorResponse: ErrorResponse = {
        success: false,
        error: 'User not found',
      };
      return res.status(401).json(errorResponse);
    }

    // Add user to request object
    req.user = {
      id: user._id.toString(),
      email: user.email,
    };

    next();
  } catch (error) {
    console.error('Authentication error:', error);
    const errorResponse: ErrorResponse = {
      success: false,
      error: 'Not authorized',
    };
    return res.status(401).json(errorResponse);
  }
};

// Role-based authorization middleware
export const authorize = (...roles: string[]) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      const errorResponse: ErrorResponse = {
        success: false,
        error: 'Not authorized to access this route',
      };
      return res.status(401).json(errorResponse);
    }

    if (!roles.includes('user')) {
      const errorResponse: ErrorResponse = {
        success: false,
        error: `User role ${'user'} is not authorized to access this route`,
      };
      return res.status(403).json(errorResponse);
    }

    next();
  };
};
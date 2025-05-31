import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';
import { generateToken, generateRefreshToken } from '../utils/jwt';
import ApiResponseHandler from '../utils/response';
import { RegisterUserRequest, LoginUserRequest } from '../types/auth.types';

/**
 * @desc    Register a new user
 * @route   POST /api/auth/register
 * @access  Public
 */
export const register = async (
  req: RegisterUserRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { name, email, password } = req.body;

    // Check if user already exists
    const userExists = await User.findOne({ email });
    if (userExists) {
      return ApiResponseHandler.error(
        res,
        'User already exists with this email',
        400
      );
    }

    // Create user
    const user = await User.create({
      name,
      email,
      password,
    });

    // Generate tokens
    const token = generateToken(user);
    const refreshToken = generateRefreshToken(user);

    // Set refresh token in HTTP-only cookie
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
    });

    // Send response
    return ApiResponseHandler.success(
      res,
      {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          household: user.household,
        },
        token,
      },
      'User registered successfully',
      201
    );
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Authenticate user & get token
 * @route   POST /api/auth/login
 * @access  Public
 */
export const login = async (
  req: LoginUserRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { email, password } = req.body;

    // Check for user email
    const user = await User.findOne({ email });
    if (!user) {
      return ApiResponseHandler.error(
        res,
        'Invalid email or password',
        401
      );
    }

    // Check password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return ApiResponseHandler.error(
        res,
        'Invalid email or password',
        401
      );
    }

    // Generate tokens
    const token = generateToken(user);
    const refreshToken = generateRefreshToken(user);

    // Set refresh token in HTTP-only cookie
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
    });

    // Send response
    return ApiResponseHandler.success(
      res,
      {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          household: user.household,
        },
        token,
      },
      'Login successful'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Logout user / clear cookie
 * @route   POST /api/auth/logout
 * @access  Private
 */
export const logout = (req: Request, res: Response) => {
  res.cookie('refreshToken', '', {
    httpOnly: true,
    expires: new Date(0),
  });
  return ApiResponseHandler.success(res, null, 'Logout successful');
};

/**
 * @desc    Get user profile
 * @route   GET /api/auth/profile
 * @access  Private
 */
export const getProfile = async (
  req: any,
  res: Response,
  next: NextFunction
) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) {
      return ApiResponseHandler.error(res, 'User not found', 404);
    }
    return ApiResponseHandler.success(res, user, 'Profile retrieved successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Refresh access token
 * @route   POST /api/auth/refresh-token
 * @access  Public
 */
export const refreshToken = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { refreshToken } = req.cookies;

    if (!refreshToken) {
      return ApiResponseHandler.error(res, 'No refresh token provided', 401);
    }

    // Verify refresh token
    if (!process.env.JWT_SECRET) {
      throw new Error('JWT_SECRET is not defined in environment variables');
    }
    
    const decoded = jwt.verify(
      refreshToken,
      process.env.JWT_SECRET
    ) as { id: string };

    // Get user from the token
    const user = await User.findById(decoded.id).select('-password');

    if (!user) {
      return ApiResponseHandler.error(res, 'User not found', 404);
    }

    // Generate new access token
    const token = generateToken(user);

    return ApiResponseHandler.success(
      res,
      { token },
      'Token refreshed successfully'
    );
  } catch (error) {
    return ApiResponseHandler.error(res, 'Invalid refresh token', 401);
  }
};

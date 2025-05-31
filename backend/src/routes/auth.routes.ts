import { Router } from 'express';
import { body } from 'express-validator';
import { validateRequest } from '../middleware/validation.middleware';
import { protect } from '../middleware/auth.middleware';
import * as authController from '../controllers/auth.controller';

const router = Router();

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user
 * @access  Public
 */
router.post(
  '/register',
  [
    body('name', 'Name is required').not().isEmpty(),
    body('email', 'Please include a valid email').isEmail(),
    body(
      'password',
      'Please enter a password with 6 or more characters'
    ).isLength({ min: 6 }),
  ],
  validateRequest,
  authController.register
);

/**
 * @route   POST /api/auth/login
 * @desc    Authenticate user & get token
 * @access  Public
 */
router.post(
  '/login',
  [
    body('email', 'Please include a valid email').isEmail(),
    body('password', 'Password is required').exists(),
  ],
  validateRequest,
  authController.login
);

/**
 * @route   POST /api/auth/logout
 * @desc    Logout user / clear cookie
 * @access  Private
 */
router.post('/logout', protect, authController.logout);

/**
 * @route   GET /api/auth/profile
 * @desc    Get user profile
 * @access  Private
 */
router.get('/profile', protect, authController.getProfile);

/**
 * @route   POST /api/auth/refresh-token
 * @desc    Refresh access token
 * @access  Public - because the user might be logged out but still has a refresh token
 */
router.post('/refresh-token', authController.refreshToken);

export default router;
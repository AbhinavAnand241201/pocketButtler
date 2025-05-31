import { Router } from 'express';
import authRoutes from './auth.routes';
// Import other route files as they are created
// import itemRoutes from './item.routes';
// import householdRoutes from './household.routes';

const router = Router();

// Health check endpoint
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'Server is running',
    timestamp: new Date().toISOString(),
  });
});

// API Routes
router.use('/auth', authRoutes);
// router.use('/items', itemRoutes);
// router.use('/households', householdRoutes);

// 404 handler for API routes
router.use('*', (req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'API endpoint not found',
  });
});

export default router;
import { Request, Response, NextFunction } from 'express';
import { validationResult, ValidationChain, ValidationError } from 'express-validator';
import ApiResponseHandler from '../utils/response';

// Type guard to check if the error is a standard validation error
const isStandardValidationError = (
  error: ValidationError
): error is ValidationError & { param: string; value: any } => {
  return 'param' in error && 'value' in error;
};

/**
 * Middleware to validate request using express-validator
 */
export const validateRequest = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return ApiResponseHandler.validationError(
      res,
      errors.array().map((err) => {
        if (isStandardValidationError(err)) {
          return {
            param: err.param,
            message: err.msg,
            value: err.value,
          };
        }
        return {
          message: err.msg,
          nestedErrors: (err as any).nestedErrors,
        };
      })
    );
  }
  next();
};

/**
 * Higher-order function to validate request with custom validations
 * @param validations Array of validation chains
 * @returns Middleware function
 */
export const validate = (validations: ValidationChain[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    await Promise.all(validations.map((validation) => validation.run(req)));

    const errors = validationResult(req);
    if (errors.isEmpty()) {
      return next();
    }

    return ApiResponseHandler.validationError(
      res,
      errors.array().map((err) => {
        if (isStandardValidationError(err)) {
          return {
            param: err.param,
            message: err.msg,
            value: err.value,
          };
        }
        return {
          message: err.msg,
          nestedErrors: (err as any).nestedErrors,
        };
      })
    );
  };
};

export default {
  validateRequest,
  validate,
};
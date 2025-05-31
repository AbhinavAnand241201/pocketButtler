import { Request } from 'express';

export interface RegisterUserRequest extends Request {
  body: {
    name: string;
    email: string;
    password: string;
  };
}

export interface LoginUserRequest extends Request {
  body: {
    email: string;
    password: string;
  };
}

export interface AuthResponse {
  success: boolean;
  data: {
    user: {
      id: string;
      name: string;
      email: string;
      household?: string;
    };
    token: string;
    refreshToken: string;
  };
}

export interface ErrorResponse {
  success: boolean;
  error: string;
  details?: any;
}

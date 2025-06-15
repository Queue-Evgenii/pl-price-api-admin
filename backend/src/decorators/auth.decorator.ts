import { applyDecorators } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { HttpErrorDto } from 'src/models/http/error-dto';
import { UserResponseDto } from 'src/models/http/user-dto';

export const ApiSignInResponses = () => {
  return applyDecorators(
    ApiOperation({ summary: 'Sign in user' }),
    ApiResponse({ status: 200, description: 'User signed in successfully', type: UserResponseDto }),
    ApiResponse({ status: 401, description: 'Wrong password', type: HttpErrorDto }),
    ApiResponse({ status: 404, description: 'User not found', type: HttpErrorDto }),
  );
};

export const ApiSignUpResponses = () => {
  return applyDecorators(
    ApiOperation({ summary: 'Register user' }),
    ApiResponse({ status: 201, description: 'User created and token issued', type: UserResponseDto }),
    ApiResponse({ status: 409, description: 'User already exists', type: HttpErrorDto }),
  );
};

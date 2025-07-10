import { applyDecorators, HttpStatus } from '@nestjs/common';
import { ApiResponse } from '@nestjs/swagger';
import { HttpErrorDto } from 'src/models/http/error-dto';

export const ApiTokenResponse = () => {
  return applyDecorators(
    ApiResponse({ status: HttpStatus.FORBIDDEN, description: 'Permission denied', type: HttpErrorDto }),
    ApiResponse({ status: HttpStatus.UNAUTHORIZED, description: 'Token has expired', type: HttpErrorDto }),
  );
};

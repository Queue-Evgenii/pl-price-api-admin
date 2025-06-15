import { applyDecorators, HttpStatus } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { CategoryResponseDto } from 'src/models/http/category-dto';
import { HttpErrorDto } from 'src/models/http/error-dto';

export const ApiCreateResponses = () => {
  return applyDecorators(
    ApiOperation({ summary: 'Creates category' }),
    ApiResponse({ status: HttpStatus.OK, description: 'Category created successfully', type: CategoryResponseDto }),
    ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'Parent ID not found', type: HttpErrorDto }),
    ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Slug must be unique', type: HttpErrorDto }),
  );
};

export const ApiFindAllResponses = () => {
  return applyDecorators(ApiOperation({ summary: 'Retrieves all categories' }), ApiResponse({ status: HttpStatus.OK, description: 'Extract categories array', type: Array<CategoryResponseDto> }));
};

export const ApiFindOneResponses = () => {
  return applyDecorators(
    ApiOperation({ summary: 'Retrieves specific category' }),
    ApiResponse({ status: HttpStatus.OK, description: 'Extract category with given ID', type: CategoryResponseDto }),
    ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'Category not found', type: HttpErrorDto }),
  );
};

export const ApiUpdateResponses = () => {
  return applyDecorators(
    ApiOperation({ summary: 'Updates specific category' }),
    ApiResponse({ status: HttpStatus.OK, description: 'Category updated successfully', type: CategoryResponseDto }),
    ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'Category with given ID not found', type: HttpErrorDto }),
    ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Slug must be unique', type: HttpErrorDto }),
  );
};

export const ApiRemoveResponses = () => {
  return applyDecorators(ApiOperation({ summary: 'Deletes specific category' }), ApiResponse({ status: 200, description: 'User signed in successfully' }));
};

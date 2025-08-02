import { PartialType } from '@nestjs/mapped-types';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsOptional, IsString, IsInt, Min } from 'class-validator';
import { CategoryEntity } from 'src/orm/category.entity';

export class CreateCategoryRequestDto {
  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty()
  @IsString()
  slug: string;

  @ApiProperty()
  @IsOptional()
  @IsInt()
  parentId?: number;

  @ApiProperty()
  @IsInt()
  @Min(1)
  orderId: number;
}

export class UpdateCategoryRequestDto extends PartialType(CreateCategoryRequestDto) {}

export class CategoryResponseDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  name: string;

  @ApiProperty()
  slug: string;

  @ApiPropertyOptional({ type: () => CategoryResponseDto })
  parent?: CategoryResponseDto;

  @ApiProperty({ type: () => [CategoryResponseDto] })
  children: CategoryResponseDto[];

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class FindAllCategoriesOptionsDto {
  @IsOptional()
  @Type(() => Boolean)
  root: boolean = true;

  @IsOptional()
  @Type(() => Number)
  @Min(1)
  page: number = 1;

  @IsOptional()
  @Type(() => Number)
  @Min(1)
  limit: number | undefined;
}

export interface FindAllCategoriesDto {
  data: CategoryEntity[];
  meta: {
    total: number;
    page: number;
    limit: number | undefined;
  };
}

export class SwapCategoriesRequestDto {
  @Type(() => Number)
  @IsInt()
  @Min(1)
  sourceId: number;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  targetId: number;
}

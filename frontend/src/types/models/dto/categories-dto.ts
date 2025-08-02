import type { CategoryEntity } from "../entities/category.entity";

export interface CategoriesMetaDto {
  page: number;
  limit: number;
  total: number;
}

export interface CategoriesDto {
  data: CategoryEntity[];
  meta: CategoriesMetaDto;
}

export interface CreateCategoryDto {
  name: string;
  slug: string;
  parentId?: number;
  orderId: number;
}

export interface SwapCategoryDto {
  sourceId: number;
  targetId: number;
}
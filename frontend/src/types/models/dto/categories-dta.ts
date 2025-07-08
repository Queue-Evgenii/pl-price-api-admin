import type { CategoryEntity } from "../entities/category.entity";

export interface CategoriesDto {
  data: CategoryEntity[];
  meta: {
    page: number;
    limit: number;
    total: number;
  }
}
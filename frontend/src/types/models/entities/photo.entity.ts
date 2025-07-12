import type { CategoryEntity } from "./category.entity";

export interface PhotoEntity {
  id: number;

  url: string;

  category: CategoryEntity;

  orderId: number;

  isActive: boolean;
}
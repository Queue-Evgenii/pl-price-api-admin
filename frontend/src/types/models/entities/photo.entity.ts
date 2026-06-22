import type { CategoryEntity } from "./category.entity";

export interface PhotoEntity {
  id: number;

  url: string;

  type: 'image' | 'video';

  category: CategoryEntity;

  orderId: number;

  isActive: boolean;

  name: string;
}
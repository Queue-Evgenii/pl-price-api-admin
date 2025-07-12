import type { PhotoEntity } from "../entities/photo.entity";

export interface PhotosDto {
  data: PhotoEntity[];
}

export interface UpdatePhotosDto {
  orderId?: number;

  isActive?: boolean;
}
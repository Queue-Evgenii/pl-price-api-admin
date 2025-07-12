import { IsBoolean, IsOptional, IsPositive } from "class-validator";
import { PhotoEntity } from "src/orm/photo.entity";

export interface FindAllPhotosDto {
  data: PhotoEntity[];
}

export class UpdatePhotoRequestDto {
  @IsOptional()
  @IsPositive()
  orderId?: number;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
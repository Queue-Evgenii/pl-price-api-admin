import { IsBoolean, IsNotEmpty, IsOptional, IsPositive, IsString, IsUrl } from "class-validator";
import { PhotoEntity } from "src/orm/photo.entity";

export interface FindAllPhotosDto {
  data: PhotoEntity[];
}

export class CreateVideoRequestDto {
  @IsString()
  @IsNotEmpty()
  @IsUrl({ require_protocol: true })
  url: string;
}

export class UpdatePhotoRequestDto {
  @IsOptional()
  @IsPositive()
  orderId?: number;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
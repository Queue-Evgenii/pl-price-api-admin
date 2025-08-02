import { CreateCategoryRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';

export interface CategoriesAdminStrategy {
  create(dto: CreateCategoryRequestDto): Promise<CategoryEntity>;

  update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity>;

  swap(sourceId: number, targetId: number): Promise<void>;

  remove(id: number): Promise<void>;
}

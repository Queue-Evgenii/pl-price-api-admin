import { CreateCategoryRequestDto, FindAllCategoriesDto, FindAllCategoriesOptionsDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';

export interface CategoriesStrategy {
  create(dto: CreateCategoryRequestDto): Promise<CategoryEntity>;

  findAll(query: FindAllCategoriesOptionsDto): Promise<FindAllCategoriesDto>;

  findOne(id: number): Promise<CategoryEntity>;

  update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity>;

  remove(id: number): Promise<void>;
}

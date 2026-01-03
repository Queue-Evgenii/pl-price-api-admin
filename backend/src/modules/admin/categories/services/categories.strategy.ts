import { CreateCategoryRequestDto, FindAllCategoriesDto, FindAllCategoriesOptionsDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';

export interface CategoriesAdminStrategy {
  create(dto: CreateCategoryRequestDto, lang: string): Promise<CategoryEntity>;

  update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity>;

  swap(sourceId: number, targetId: number): Promise<void>;

  remove(id: number): Promise<void>;
  
  findAll(query: FindAllCategoriesOptionsDto, lang: string): Promise<FindAllCategoriesDto>;
  
  findOne(id: number): Promise<CategoryEntity>;

  findRootById(id: number): Promise<CategoryEntity>;

  findOneBySlug(slug: string): Promise<CategoryEntity>;
}

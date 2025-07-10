import { FindAllCategoriesDto, FindAllCategoriesOptionsDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';

export interface CategoriesStrategy {
  findAll(query: FindAllCategoriesOptionsDto): Promise<FindAllCategoriesDto>;

  findOne(id: number): Promise<CategoryEntity>;

  findRootById(id: number): Promise<CategoryEntity>;
}

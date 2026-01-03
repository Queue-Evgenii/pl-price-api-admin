import { FindAllCategoriesDto, FindAllCategoriesOptionsDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';

export interface CategoriesStrategy {
  findAll(query: FindAllCategoriesOptionsDto, lang: string): Promise<FindAllCategoriesDto>;

  findOne(id: number, lang: string): Promise<CategoryEntity>;
}

import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindAllCategoriesDto, FindAllCategoriesOptionsDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';
import { TreeRepository } from 'typeorm';
import { CategoriesStrategy } from './categories.strategy';

@Injectable()
export class CategoriesService implements CategoriesStrategy {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: TreeRepository<CategoryEntity>,
  ) {}

  async findAll(params: FindAllCategoriesOptionsDto): Promise<FindAllCategoriesDto> {
    const query = this.categoryRepo.createQueryBuilder('category');

    if (params.root) {
      query.where('category.parentId IS NULL');
    }

    query
      .orderBy('category.createdAt', 'DESC')
      .skip((params.page - 1) * params.limit)
      .take(params.limit);

    const [roots, total] = await query.getManyAndCount();

    const data = await Promise.all(roots.map((root) => this.categoryRepo.findDescendantsTree(root)));

    return {
      data,
      meta: {
        total,
        page: params.page,
        limit: params.limit,
      },
    };
  }

  async findOne(id: number): Promise<CategoryEntity> {
    const category = await this.categoryRepo.findOne({ where: { id }, relations: ['parent'] });

    if (!category) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    const fullTree = await this.categoryRepo.findDescendantsTree(category);

    return fullTree;
  }

  async findRootById(id: number): Promise<CategoryEntity> {
    const category = await this.categoryRepo.findOne({ where: { id } });

    if (!category) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    return category;
  }
}

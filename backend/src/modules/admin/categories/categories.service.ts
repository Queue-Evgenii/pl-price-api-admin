import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateCategoryRequestDto, FindAllCategoriesDto, FindAllCategoriesOptionsDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';
import { TreeRepository } from 'typeorm';
import { CategoriesStrategy } from './categories.strategy';

@Injectable()
export class CategoriesService implements CategoriesStrategy {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: TreeRepository<CategoryEntity>,
  ) {}

  private async throwIfSlugExists(slug: string | undefined) {
    if (slug === undefined || (await this.categoryRepo.findOne({ where: { slug } }))) throw new HttpException('Slug must be unique', HttpStatus.BAD_REQUEST);
  }

  async create(dto: CreateCategoryRequestDto): Promise<CategoryEntity> {
    await this.throwIfSlugExists(dto.slug);

    const category = new CategoryEntity();
    category.name = dto.name;
    category.slug = dto.slug;

    if (dto.parentId) {
      const parent = await this.categoryRepo.findOne({
        where: { id: dto.parentId },
      });
      if (!parent) throw new HttpException('Parent ID not found', HttpStatus.NOT_FOUND);
      category.parent = parent;
    }

    const createCategory = this.categoryRepo.save(category);
    return this.findOne((await createCategory).id);
  }

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
    const category = await this.categoryRepo.findOne({ where: { id }, relations: ['parent']});

    if (!category) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    const fullTree = await this.categoryRepo.findDescendantsTree(category);

    return fullTree;
  }

  async update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity> {
    const category = await this.findOne(id);
    if (category.slug !== dto.slug) await this.throwIfSlugExists(dto.slug);

    if (dto.name !== undefined) category.name = dto.name;
    if (dto.slug !== undefined) category.slug = dto.slug;

    if (dto.parentId !== undefined) {
      if (dto.parentId === null) {
        category.parent = null;
      } else {
        const parent = await this.categoryRepo.findOne({
          where: { id: dto.parentId },
        });
        if (!parent) throw new HttpException('Category with given ID not found', HttpStatus.NOT_FOUND);
        category.parent = parent;
      }
    }

    return this.categoryRepo.save(category);
  }

  async remove(id: number): Promise<void> {
    const category = await this.categoryRepo.findOne({ where: { id } });

    if (!category) {
      throw new HttpException(`Category with id=${id} not found`, HttpStatus.NOT_FOUND);
    }

    const descendants = await this.categoryRepo.findDescendants(category);
    await this.categoryRepo.remove(descendants.reverse());
  }
}

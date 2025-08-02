import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateCategoryRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';
import { TreeRepository } from 'typeorm';
import { CategoriesStrategy } from 'src/modules/categories/services/categories.strategy';
import { CategoriesAdminStrategy } from './categories.strategy';

@Injectable()
export class CategoriesAdminService implements CategoriesAdminStrategy {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: TreeRepository<CategoryEntity>,
    @Inject('CategoriesService') private categoriesService: CategoriesStrategy,
  ) {}

  private async throwIfSlugExists(slug: string | undefined) {
    if (slug === undefined || (await this.categoryRepo.findOne({ where: { slug } }))) throw new HttpException('Slug must be unique', HttpStatus.BAD_REQUEST);
  }

  async create(dto: CreateCategoryRequestDto): Promise<CategoryEntity> {
    await this.throwIfSlugExists(dto.slug);

    const category = new CategoryEntity();
    category.name = dto.name;
    category.slug = dto.slug;
    category.orderId = dto.orderId;

    if (dto.parentId) {
      const parent = await this.categoriesService.findRootById(dto.parentId);
      if (!parent) throw new HttpException('Parent ID not found', HttpStatus.NOT_FOUND);
      category.parent = parent;
    }

    const createCategory = this.categoryRepo.save(category);
    return this.categoriesService.findOne((await createCategory).id);
  }

  async update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity> {
    const category = await this.categoriesService.findOne(id);
    if (category.slug !== dto.slug) await this.throwIfSlugExists(dto.slug);

    if (dto.name !== undefined) category.name = dto.name;
    if (dto.slug !== undefined) category.slug = dto.slug;

    if (dto.parentId !== undefined) {
      if (dto.parentId === null) {
        category.parent = null;
      } else {
        const parent = await this.categoriesService.findRootById(dto.parentId);
        if (!parent) throw new HttpException('Category with given ID not found', HttpStatus.NOT_FOUND);
        category.parent = parent;
      }
    }

    return this.categoryRepo.save(category);
  }

  async swap(sourceId: number, targetId: number): Promise<void> {
    const source = await this.categoriesService.findOne(sourceId);
    const target = await this.categoriesService.findOne(targetId);

    if (!source || !target) {
      throw new HttpException('One or both categories not found', HttpStatus.NOT_FOUND);
    }

    if ((!source.parent && target.parent) || (source.parent && !target.parent) || (source.parent && target.parent && source.parent.id !== target.parent.id)) {
      throw new HttpException('Categories not in one subdirectory', HttpStatus.BAD_REQUEST);
    }

    const tempOrder = source.orderId;
    source.orderId = target.orderId;
    target.orderId = tempOrder;

    await this.categoryRepo.save([source, target]);
  }

  async remove(id: number): Promise<void> {
    const category = await this.categoriesService.findRootById(id);

    if (!category) {
      throw new HttpException(`Category with id=${id} not found`, HttpStatus.NOT_FOUND);
    }

    const descendants = await this.categoryRepo.findDescendants(category);
    await this.categoryRepo.remove(descendants.reverse());
  }
}

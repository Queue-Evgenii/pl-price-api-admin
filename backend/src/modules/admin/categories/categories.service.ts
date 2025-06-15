import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateCategoryRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';
import { Repository } from 'typeorm';
import { CategoriesStrategy } from './categories.strategy';

@Injectable()
export class CategoriesService implements CategoriesStrategy {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: Repository<CategoryEntity>,
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

    return this.categoryRepo.save(category);
  }

  async findAll(): Promise<CategoryEntity[]> {
    return this.categoryRepo.find({
      relations: ['parent', 'children'],
    });
  }

  async findOne(id: number): Promise<CategoryEntity> {
    const category = await this.categoryRepo.findOne({
      where: { id },
      relations: ['parent', 'children'],
    });
    if (!category) throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    return category;
  }

  async update(id: number, dto: UpdateCategoryRequestDto): Promise<CategoryEntity> {
    const category = await this.findOne(id);
    await this.throwIfSlugExists(dto.slug);

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
    const category = await this.findOne(id);
    await this.categoryRepo.remove(category);
  }
}

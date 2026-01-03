import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateCategoryRequestDto, FindAllCategoriesDto, FindAllCategoriesOptionsDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoryEntity } from 'src/orm/category.entity';
import { TreeRepository } from 'typeorm';
import { CategoriesAdminStrategy } from './categories.strategy';
import { SiteEntity } from 'src/orm/site.entity';

@Injectable()
export class CategoriesAdminService implements CategoriesAdminStrategy {
  constructor(
    @InjectRepository(SiteEntity)
    private readonly siteRepo: TreeRepository<SiteEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: TreeRepository<CategoryEntity>,
  ) {}

  private async throwIfSlugExists(slug: string | undefined) {
    if (slug === undefined || (await this.categoryRepo.findOne({ where: { slug } }))) throw new HttpException('Slug must be unique', HttpStatus.BAD_REQUEST);
  }

  async create(dto: CreateCategoryRequestDto, lang: string = 'pl'): Promise<CategoryEntity> {
    await this.throwIfSlugExists(dto.slug);

    const site = await this.siteRepo.findOne({
      where: { code: lang },
    });

    if (!site) {
      throw new HttpException(`Site with code "${lang}" not found`, HttpStatus.BAD_REQUEST);
    }

    const category = new CategoryEntity();
    category.name = dto.name;
    category.slug = dto.slug;
    category.orderId = dto.orderId;
    category.site = site;

    if (dto.parentId) {
      const parent = await this.categoryRepo.findOne({
        where: { id: dto.parentId },
        relations: ['site'],
      });

      if (!parent) {
        throw new HttpException('Parent ID not found', HttpStatus.NOT_FOUND);
      }

      if (parent.site.id !== site.id) {
        throw new HttpException('Parent category belongs to another language', HttpStatus.BAD_REQUEST);
      }

      category.parent = parent;
    }

    const saved = await this.categoryRepo.save(category);
    return this.findOne(saved.id);
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
        const parent = await this.findRootById(dto.parentId);
        if (!parent) throw new HttpException('Category with given ID not found', HttpStatus.NOT_FOUND);
        category.parent = parent;
      }
    }

    return this.categoryRepo.save(category);
  }

  async swap(sourceId: number, targetId: number): Promise<void> {
    const source = await this.findOne(sourceId);
    const target = await this.findOne(targetId);

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
    const category = await this.findRootById(id);

    if (!category) {
      throw new HttpException(`Category with id=${id} not found`, HttpStatus.NOT_FOUND);
    }

    const descendants = await this.categoryRepo.findDescendants(category);
    await this.categoryRepo.remove(descendants.reverse());
  }

  async findAll(params: FindAllCategoriesOptionsDto, lang: string = 'pl'): Promise<FindAllCategoriesDto> {
    const query = this.categoryRepo.createQueryBuilder('category').leftJoin('category.site', 'site').where('site.code = :lang', { lang });

    if (params.root) {
      query.andWhere('category.parentId IS NULL');
    }

    query.orderBy('category.orderId', 'ASC');

    if (params.limit) {
      query.skip((params.page - 1) * params.limit).take(params.limit);
    }

    const [roots, total] = await query.getManyAndCount();
    if (roots.length === 0) {
      return {
        data: [],
        meta: {
          total: 0,
          page: params.page,
          limit: params.limit,
        },
      };
    }

    const trees = await Promise.all(roots.map((root) => this.categoryRepo.findDescendantsTree(root)));

    const sortChildren = (node: CategoryEntity): CategoryEntity => {
      if (node.children) {
        node.children = node.children.sort((a, b) => a.orderId - b.orderId).map(sortChildren);
      }
      return node;
    };

    const sortedTrees = trees.map(sortChildren);

    const allCategories: CategoryEntity[] = [];
    const collectIds = (node: CategoryEntity) => {
      allCategories.push(node);
      node.children?.forEach(collectIds);
    };
    sortedTrees.forEach(collectIds);
    const allIds = allCategories.map((c) => c.id);

    const photoCounts = await this.categoryRepo.manager
      .createQueryBuilder()
      .select('photo.categoryId', 'categoryId')
      .addSelect('COUNT(*)', 'count')
      .from('photo_entity', 'photo')
      .where('photo.isActive = true')
      .andWhere('photo.categoryId IN (:...ids)', { ids: allIds })
      .groupBy('photo.categoryId')
      .getRawMany<{ categoryId: string; count: string }>();

    const countMap = new Map<number, number>();
    photoCounts.forEach((row) => {
      countMap.set(Number(row.categoryId), Number(row.count));
    });

    const attachCountPhotos = (node: CategoryEntity): CategoryEntity => ({
      ...node,
      countPhotos: countMap.get(node.id) || 0,
      children: node.children?.map(attachCountPhotos) || [],
    });

    const data = sortedTrees.map(attachCountPhotos);

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

  async findOneBySlug(slug: string): Promise<CategoryEntity> {
    const category = await this.categoryRepo.findOne({ where: { slug }, relations: ['parent'] });

    if (!category) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    const fullTree = await this.categoryRepo.findDescendantsTree(category);

    return fullTree;
  }
}

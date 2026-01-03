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

  async findAll(params: FindAllCategoriesOptionsDto, lang: string = 'pl'): Promise<FindAllCategoriesDto> {
    const query = this.categoryRepo.createQueryBuilder('category').leftJoin('category.site', 'site').where('site.code = :lang AND site.active = true', { lang });

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

  async findOne(id: number, lang: string = 'pl'): Promise<CategoryEntity> {
    const category = await this.categoryRepo.findOne({ where: { id, site: { code: lang, active: true } }, relations: ['parent'] });

    if (!category) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    const fullTree = await this.categoryRepo.findDescendantsTree(category);

    return fullTree;
  }
}

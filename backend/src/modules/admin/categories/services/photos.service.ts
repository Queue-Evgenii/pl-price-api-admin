import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryEntity } from 'src/orm/category.entity';
import { Repository } from 'typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { CategoriesStrategy } from 'src/modules/categories/services/categories.strategy';
import { PhotosService } from 'src/modules/categories/services/photos.service';

@Injectable()
export class PhotosAdminService {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
    @Inject('CategoriesService') private categoriesService: CategoriesStrategy,
    private photosService: PhotosService,
  ) {}

  async create(categoryId: number, filename: string): Promise<PhotoEntity[]> {
    const category = await this.categoriesService.findOne(categoryId);

    const photo = this.photosRepo.create({
      path: `uploads/categories/images/${filename}`,
      category,
    });

    await this.photosRepo.save(photo);
    return this.photosService.findAll(categoryId);
  }
}

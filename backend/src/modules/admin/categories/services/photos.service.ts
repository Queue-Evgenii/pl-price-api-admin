import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { CategoriesStrategy } from 'src/modules/categories/services/categories.strategy';
import { PhotosService } from 'src/modules/categories/services/photos.service';
import { ConfigService } from '@nestjs/config';
import { FindAllPhotosDto, UpdatePhotoRequestDto } from 'src/models/http/photos-dto';
import * as fs from 'fs';
import * as path from 'path';
import { promisify } from 'util';

@Injectable()
export class PhotosAdminService {
  constructor(
    @InjectRepository(PhotoEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
    @Inject('CategoriesService') private categoriesService: CategoriesStrategy,
    private photosService: PhotosService,
    private readonly configService: ConfigService,
  ) {}

  async create(categoryId: number, filename: string): Promise<PhotoEntity> {
    const category = await this.categoriesService.findOne(categoryId);
    const maxOrder = await this.photosRepo.maximum('orderId');
    const apiUrl = this.configService.get<string>('API_URL');

    const photo = this.photosRepo.create({
      url: `${apiUrl}/uploads/categories/photos/${filename}`,
      category,
      orderId: (maxOrder ?? 0) + 1,
    });

    return this.photosRepo.save(photo);
  }

  async update(id: number, dto: UpdatePhotoRequestDto): Promise<FindAllPhotosDto> {
    const photo = await this.photosService.findOne(id, true);

    if (dto.orderId !== undefined) {
      const needsToUpdate = await this.photosRepo.findOne({ where: { category: { id: photo.category.id }, orderId: dto.orderId }, relations: ['category'] });

      if (needsToUpdate !== null) {
        needsToUpdate.orderId = photo.orderId;
        photo.orderId = -1;

        await this.photosRepo.save(photo);
        await this.photosRepo.save(needsToUpdate);
      }

      photo.orderId = dto.orderId;
    }
    if (dto.isActive !== undefined) photo.isActive = dto.isActive;

    const categoryId = photo.category.id;
    await this.photosRepo.save(photo);
    return this.photosService.findAll(categoryId);
  }

  async remove(id: number): Promise<FindAllPhotosDto> {
    const photo = await this.photosService.findOne(id, true);
    const categoryId = photo.category.id;
    const orderId = photo.orderId;
    const unlinkAsync = promisify(fs.unlink);

    try {
      const fileUrl = photo.url;
      const fileName = fileUrl.split('/uploads/')[1];
      const filePath = path.join(process.cwd(), 'uploads', fileName);

      await unlinkAsync(filePath);
    } catch (error: unknown) {
      if (error instanceof Error) {
        console.warn('Ошибка при удалении файла:', error.message);
      } else {
        console.warn('Ошибка при удалении файла:', error);
      }
    }

    await this.photosRepo.remove(photo);

    const needsToUpdate = await this.photosService.findAll(categoryId);
    await Promise.all(needsToUpdate.data.filter((el) => el.orderId > orderId).map((el) => this.update(el.id, { orderId: el.orderId - 1 })));
    return this.photosService.findAll(categoryId);
  }
}

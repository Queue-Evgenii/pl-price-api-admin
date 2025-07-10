import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryEntity } from 'src/orm/category.entity';
import { Repository } from 'typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';

@Injectable()
export class PhotosService {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
  ) {}

  async findAll(categoryId: number): Promise<PhotoEntity[]> {
    return this.photosRepo.find({ where: { category: { id: categoryId } } });
  }
}

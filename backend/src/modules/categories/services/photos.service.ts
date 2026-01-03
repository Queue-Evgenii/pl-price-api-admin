import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { FindAllPhotosDto } from 'src/models/http/photos-dto';
import { CategoryEntity } from 'src/orm/category.entity';

@Injectable()
export class PhotosService {
  constructor(
    @InjectRepository(PhotoEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoryRepo: Repository<CategoryEntity>,
  ) {}

  async findAll(slug: string, lang: string = 'pl'): Promise<FindAllPhotosDto> {
    const cat = await this.categoryRepo.find({ where: { slug, site: { code: lang, active: true } } });

    if (cat && cat.length === 0) throw new HttpException(`Category not found`, HttpStatus.NOT_FOUND);

    const data = await this.photosRepo.find({ where: { category: { slug } }, relations: ['category'], order: { orderId: 'ASC' } });
    return { data };
  }
}

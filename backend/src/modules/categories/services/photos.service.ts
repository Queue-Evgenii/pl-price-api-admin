import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { FindAllPhotosDto } from 'src/models/http/photos-dto';

@Injectable()
export class PhotosService {
  constructor(
    @InjectRepository(PhotoEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
  ) {}

  async findAll(slug: string): Promise<FindAllPhotosDto> {
    const data = await this.photosRepo.find({ where: { category: { slug } }, relations: ['category'], order: { orderId: 'ASC' } });
    return { data };
  }

  async findOne(id: number, relations: boolean = false): Promise<PhotoEntity> {
    const photo = await (relations ? this.photosRepo.findOne({ where: { id }, relations: ['category'] }) : this.photosRepo.findOne({ where: { id } }));

    if (photo === null) throw new HttpException(`Photo with id=${id} not found`, HttpStatus.NOT_FOUND);

    return photo;
  }
}

import { Module } from '@nestjs/common';
import { CategoryEntity } from 'src/orm/category.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { CategoriesController } from './controllers/categories.controller';
import { PhotosController } from './controllers/photos.controller';
import { CategoriesService } from './services/categories.service';
import { PhotosService } from './services/photos.service';

@Module({
  imports: [TypeOrmModule.forFeature([CategoryEntity, PhotoEntity])],
  controllers: [CategoriesController, PhotosController],
  providers: [
    {
      provide: 'CategoriesService',
      useClass: CategoriesService,
    },
    PhotosService,
  ],
  exports: ['CategoriesService', PhotosService],
})
export class CategoriesModule {}

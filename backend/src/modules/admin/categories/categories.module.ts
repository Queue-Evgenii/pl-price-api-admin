import { Module } from '@nestjs/common';
import { CategoriesController } from './controllers/categories.controller';
import { CategoriesAdminService } from './services/categories.service';
import { CategoryEntity } from 'src/orm/category.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PhotosAdminController } from './controllers/photos.controller';
import { PhotoEntity } from 'src/orm/photo.entity';
import { PhotosAdminService } from './services/photos.service';
import { CategoriesModule } from 'src/modules/categories/categories.module';

@Module({
  imports: [TypeOrmModule.forFeature([CategoryEntity, PhotoEntity]), CategoriesModule],
  controllers: [CategoriesController, PhotosAdminController],
  providers: [
    {
      provide: 'CategoriesAdminService',
      useClass: CategoriesAdminService,
    },
    PhotosAdminService,
  ],
})
export class CategoriesAdminModule {}

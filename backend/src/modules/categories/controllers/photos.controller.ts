import { Controller, Get, Param, UsePipes, ValidationPipe } from '@nestjs/common';
import { PhotosService } from '../services/photos.service';

@Controller('categories/:slug/photos')
export class PhotosController {
  constructor(private photosService: PhotosService) {}

  @Get()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('slug') slug: string) {
    return this.photosService.findAll(slug);
  }
}

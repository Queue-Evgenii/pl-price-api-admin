import { Controller, Get, Param, UsePipes, ValidationPipe, Headers } from '@nestjs/common';
import { PhotosService } from '../services/photos.service';

@Controller('categories/:slug/photos')
export class PhotosController {
  constructor(private photosService: PhotosService) {}

  @Get()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('slug') slug: string, @Headers('content-language') lang: string) {
    return this.photosService.findAll(slug, lang);
  }
}

import { Controller, Get, Param, UsePipes, ValidationPipe } from '@nestjs/common';
import { PhotosService } from '../services/photos.service';

@Controller('categories/:id/photos')
export class PhotosController {
  constructor(private photosService: PhotosService) {}

  @Get()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('id') id: number) {
    return this.photosService.findAll(id);
  }
}

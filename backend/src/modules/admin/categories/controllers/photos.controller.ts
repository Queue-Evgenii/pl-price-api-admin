import { Body, Controller, Get, Param, Post, UploadedFile, UseGuards, UseInterceptors, UsePipes, ValidationPipe } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { ApiTokenResponse } from 'src/decorators/token.decorator';
import { FileInterceptor } from '@nestjs/platform-express';
import { PhotosAdminService } from '../services/photos.service';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { PhotosService } from 'src/modules/categories/services/photos.service';

@Controller('categories/:id/photos')
export class PhotosAdminController {
  constructor(
    private photosAdminService: PhotosAdminService,
    private photosService: PhotosService,
  ) {}

  @Post()
  @UseGuards(AuthGuard)
  @ApiTokenResponse()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads/categories/photos',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          cb(null, `${file.fieldname}-${uniqueSuffix}${ext}`);
        },
      }),
    }),
  )
  create(@Param('id') id: number, @UploadedFile() file: Express.Multer.File) {
    return this.photosAdminService.create(id, file.filename);
  }

  @Get()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('id') id: number) {
    return this.photosService.findAll(id);
  }
}

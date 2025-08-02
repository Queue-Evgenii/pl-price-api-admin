import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, UploadedFile, UseGuards, UseInterceptors, UsePipes, ValidationPipe } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { ApiTokenResponse } from 'src/decorators/token.decorator';
import { FileInterceptor } from '@nestjs/platform-express';
import { PhotosAdminService } from '../services/photos.service';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { PhotosService } from 'src/modules/categories/services/photos.service';
import { UpdatePhotoRequestDto } from 'src/models/http/photos-dto';

@Controller()
export class PhotosAdminController {
  constructor(
    private photosAdminService: PhotosAdminService,
    private photosService: PhotosService,
  ) {}

  @Post('categories/:slug/photos')
  @UseGuards(AuthGuard)
  @ApiTokenResponse()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads/categories/photos',
        filename: (req, file, cb) => {
          const timestamp = Date.now();
          const random = Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          const baseName = file.originalname.replace(ext, '');
          const slugified = baseName.replace(/\s+/g, '-').toLowerCase();
          cb(null, `${slugified}--${timestamp}-${random}${ext}`);
        },
      }),
      limits: { fileSize: 10 * 1024 * 1024 },
    }),
  )
  create(@Param('slug') slug: string, @UploadedFile() file: Express.Multer.File) {
    return this.photosAdminService.create(slug, file.filename);
  }

  @Get('categories/:slug/photos')
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('slug') slug: string) {
    return this.photosService.findAll(slug);
  }

  @Patch('photos/:id')
  @UseGuards(AuthGuard)
  @ApiTokenResponse()
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdatePhotoRequestDto) {
    return this.photosAdminService.update(id, dto);
  }

  @Delete('photos/:id')
  @UseGuards(AuthGuard)
  @ApiTokenResponse()
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.photosAdminService.remove(id);
  }
}

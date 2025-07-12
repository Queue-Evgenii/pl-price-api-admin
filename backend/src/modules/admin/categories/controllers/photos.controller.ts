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
@UseGuards(AuthGuard)
export class PhotosAdminController {
  constructor(
    private photosAdminService: PhotosAdminService,
    private photosService: PhotosService,
  ) {}

  @Post('categories/:id/photos')
  @ApiTokenResponse()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads/categories/photos',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          cb(null, `${uniqueSuffix}${ext}`);
        },
      }),
    }),
  )
  create(@Param('id') id: number, @UploadedFile() file: Express.Multer.File) {
    return this.photosAdminService.create(id, file.filename);
  }

  @Get('categories/:id/photos')
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Param('id') id: number) {
    return this.photosService.findAll(id);
  }

  @Patch('photos/:id')
  @ApiTokenResponse()
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdatePhotoRequestDto) {
    return this.photosAdminService.update(id, dto);
  }

  @Delete('photos/:id')
  @ApiTokenResponse()
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.photosAdminService.remove(id);
  }
}

import { Body, Controller, Delete, Get, Headers, Param, ParseIntPipe, Patch, Post, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { ApiFindOneResponses, ApiUpdateResponses } from 'src/decorators/categories.decorator';
import { ApiTokenResponse } from 'src/decorators/token.decorator';
import { UpdateSettingRequestDto } from 'src/models/http/settings-dto';
import { SettingsAdminService } from '../services/settings.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

@Controller('settings')
@UseGuards(AuthGuard)
export class SettingsAdminController {
  constructor(private readonly settingsAdminService: SettingsAdminService) {}

  @Get()
  @ApiFindOneResponses()
  findOne(@Headers('content-language') lang: string) {
    return this.settingsAdminService.findOne(lang);
  }

  @Patch()
  @ApiUpdateResponses()
  @ApiTokenResponse()
  update(@Headers('content-language') lang: string, @Body() dto: UpdateSettingRequestDto) {
    return this.settingsAdminService.update(lang, dto);
  }

  @Post('banner')
  @ApiTokenResponse()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads/photos',
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
  createSeparately(@Headers('content-language') lang: string, @UploadedFile() file: Express.Multer.File) {
    return this.settingsAdminService.createBanner(lang, file.filename);
  }

  @Delete('banner/:id')
  @ApiTokenResponse()
  removeBanner(@Param('id', ParseIntPipe) id: number) {
    return this.settingsAdminService.removeBanner(id);
  }
}

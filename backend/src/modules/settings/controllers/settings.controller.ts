import { Body, Controller, Get, Headers } from '@nestjs/common';
import { ApiFindOneResponses } from 'src/decorators/categories.decorator';
import { SettingsService } from '../services/settings.service';

@Controller('settings')
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  @Get()
  @ApiFindOneResponses()
  findOne(@Headers('content-language') lang: string) {
    return this.settingsService.findOne(lang);
  }
}

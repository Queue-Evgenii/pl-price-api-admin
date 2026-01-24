import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SettingsEntity } from 'src/orm/settings.entity';

@Injectable()
export class SettingsService {
  constructor(
    @InjectRepository(SettingsEntity)
    private readonly settingsRepo: Repository<SettingsEntity>,
  ) {}

  async findOne(lang: string = 'pl'): Promise<SettingsEntity | null> {
    const settings = await this.settingsRepo.findOne({
      where: {
        site: {
          code: lang,
        },
      },
      relations: ['site', 'banner'],
    });

    return settings;
  }
}

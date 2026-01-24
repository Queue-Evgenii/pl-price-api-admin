import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, TreeRepository } from 'typeorm';
import { SiteEntity } from 'src/orm/site.entity';
import { SettingsEntity } from 'src/orm/settings.entity';
import { UpdateSettingRequestDto } from 'src/models/http/settings-dto';
import { PhotoEntity } from 'src/orm/photo.entity';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';
import { promisify } from 'util';

@Injectable()
export class SettingsAdminService {
  constructor(
    @InjectRepository(SiteEntity)
    private readonly siteRepo: TreeRepository<SiteEntity>,
    @InjectRepository(SettingsEntity)
    private readonly settingsRepo: Repository<SettingsEntity>,
    @InjectRepository(PhotoEntity)
    private readonly photosRepo: Repository<PhotoEntity>,
    private readonly configService: ConfigService,
  ) {}

  async create(lang: string = 'pl'): Promise<SettingsEntity> {
    const site = await this.siteRepo.findOne({
      where: { code: lang },
    });

    if (!site) {
      throw new HttpException(`Site with code "${lang}" not found`, HttpStatus.BAD_REQUEST);
    }

    const settings = this.settingsRepo.create({
      site,
    });

    return this.settingsRepo.save(settings);
  }

  async update(lang: string = 'pl', dto: UpdateSettingRequestDto): Promise<SettingsEntity> {
    let settings = await this.settingsRepo.findOne({
      where: {
        site: {
          code: lang,
        },
      },
    });
    if (!settings) {
      settings = await this.create(lang);
    }

    Object.assign(settings, dto);

    return this.settingsRepo.save(settings);
  }

  async findOne(lang: string = 'pl'): Promise<SettingsEntity> {
    const settings = await this.settingsRepo.findOne({
      where: {
        site: {
          code: lang,
        },
      },
      relations: ['site', 'banner'],
    });

    if (settings) {
      return settings;
    }

    return this.create(lang);
  }

  async createBanner(lang: string, filename: string): Promise<PhotoEntity> {
    const settings = await this.settingsRepo.findOne({
      where: {
        site: {
          code: lang,
        },
      },
    });

    if (!settings) {
      throw new HttpException(`Setting with site "${lang}" not found`, HttpStatus.BAD_REQUEST);
    }

    const apiUrl = this.configService.get<string>('API_URL');

    const photo = this.photosRepo.create({
      url: `${apiUrl}/uploads/photos/${filename}`,
      name: filename,
      orderId: 0,
      settings,
    });

    return this.photosRepo.save(photo);
  }

  async removeBanner(id: number): Promise<PhotoEntity> {
    const photo = await this.photosRepo.findOne({ where: { id } });

    if (!photo) {
      throw new HttpException(`Photo with ID "${id}" not found`, HttpStatus.BAD_REQUEST);
    }
    const unlinkAsync = promisify(fs.unlink);

    try {
      const fileUrl = photo.url;
      const fileName = fileUrl.split('/uploads/')[1];
      const filePath = path.join(process.cwd(), 'uploads', fileName);

      await unlinkAsync(filePath);
    } catch (error: unknown) {
      if (error instanceof Error) {
        console.warn('Ошибка при удалении файла:', error.message);
      } else {
        console.warn('Ошибка при удалении файла:', error);
      }
    }

    return await this.photosRepo.remove(photo);
  }
}

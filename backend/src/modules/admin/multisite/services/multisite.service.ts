import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SiteEntity } from 'src/orm/site.entity';
import { MultisiteAdminStrategy } from './multisite.strategy';
import { CreateSiteRequestDto, UpdateSiteRequestDto } from 'src/models/http/site-dto';

@Injectable()
export class MultisiteAdminService implements MultisiteAdminStrategy {
  constructor(
    @InjectRepository(SiteEntity)
    private readonly siteRepo: Repository<SiteEntity>,
  ) {}

  async create(dto: CreateSiteRequestDto): Promise<SiteEntity> {
    const existing = await this.siteRepo.findOne({ where: { code: dto.code } });
    if (existing) {
      throw new HttpException('Site with this code already exists', HttpStatus.CONFLICT);
    }
    const site = this.siteRepo.create(dto);
    return this.siteRepo.save(site);
  }

  async update(id: number, dto: UpdateSiteRequestDto): Promise<SiteEntity> {
    const site = await this.siteRepo.findOne({ where: { id } });
    if (!site) {
      throw new HttpException('Site not found', HttpStatus.NOT_FOUND);
    }

    Object.assign(site, dto);
    return this.siteRepo.save(site);
  }

  async remove(id: number): Promise<void> {
    const site = await this.siteRepo.findOne({ where: { id } });
    if (!site) {
      throw new HttpException('Site not found', HttpStatus.NOT_FOUND);
    }
    await this.siteRepo.remove(site);
  }

  async findOne(id: number): Promise<SiteEntity> {
    const site = await this.siteRepo.findOne({ where: { id } });
    if (!site) {
      throw new HttpException('Site not found', HttpStatus.NOT_FOUND);
    }
    return site;
  }

  async findAll(): Promise<SiteEntity[]> {
    return await this.siteRepo.find();
  }

  async findActive(): Promise<SiteEntity[]> {
    return await this.siteRepo.find({ where: { active: true }});
  }
}

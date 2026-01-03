import { CreateSiteRequestDto, UpdateSiteRequestDto } from 'src/models/http/site-dto';
import { SiteEntity } from 'src/orm/site.entity';

export interface MultisiteAdminStrategy {
  create(dto: CreateSiteRequestDto): Promise<SiteEntity>;

  update(id: number, dto: UpdateSiteRequestDto): Promise<SiteEntity>;

  remove(id: number): Promise<void>;

  findOne(id: number): Promise<SiteEntity>;

  findAll(): Promise<SiteEntity[]>;

  findActive(): Promise<SiteEntity[]>;
}

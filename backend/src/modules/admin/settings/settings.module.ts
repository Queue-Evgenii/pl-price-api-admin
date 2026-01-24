import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { SiteEntity } from 'src/orm/site.entity';
import { SettingsEntity } from 'src/orm/settings.entity';
import { SettingsAdminController } from './controllers/settings.controller';
import { SettingsAdminService } from './services/settings.service';

@Module({
  imports: [TypeOrmModule.forFeature([SettingsEntity, PhotoEntity, SiteEntity])],
  controllers: [SettingsAdminController],
  providers: [SettingsAdminService],
})
export class SettingsAdminModule {}

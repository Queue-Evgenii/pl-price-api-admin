import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PhotoEntity } from 'src/orm/photo.entity';
import { SettingsEntity } from 'src/orm/settings.entity';
import { SettingsService } from './services/settings.service';
import { SettingsController } from './controllers/settings.controller';

@Module({
  imports: [TypeOrmModule.forFeature([SettingsEntity, PhotoEntity])],
  controllers: [SettingsController],
  providers: [SettingsService],
})
export class SettingsModule {}

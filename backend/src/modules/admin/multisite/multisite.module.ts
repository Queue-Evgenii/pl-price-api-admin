import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SiteEntity } from 'src/orm/site.entity';
import { MultisiteController } from './controllers/multisite.controller';
import { MultisiteAdminService } from './services/multisite.service';

@Module({
  imports: [TypeOrmModule.forFeature([SiteEntity])],
  controllers: [MultisiteController],
  providers: [
    {
      provide: 'MultisiteAdminService',
      useClass: MultisiteAdminService,
    }
  ],
})
export class MultisiteAdminModule {}

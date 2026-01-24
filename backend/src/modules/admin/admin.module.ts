import { Module } from '@nestjs/common';
import { CategoriesAdminModule } from './categories/categories.module';
import { MultisiteAdminModule } from './multisite/multisite.module';
import { SettingsAdminModule } from './settings/settings.module';

@Module({
  imports: [CategoriesAdminModule, MultisiteAdminModule, SettingsAdminModule],
})
export class AdminModule {}

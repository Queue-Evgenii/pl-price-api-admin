import { Module } from '@nestjs/common';
import { CategoriesAdminModule } from './categories/categories.module';
import { MultisiteAdminModule } from './multisite/multisite.module';

@Module({
  imports: [CategoriesAdminModule, MultisiteAdminModule],
})
export class AdminModule {}

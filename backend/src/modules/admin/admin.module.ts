import { Module } from '@nestjs/common';
import { CategoriesAdminModule } from './categories/categories.module';

@Module({
  imports: [CategoriesAdminModule],
})
export class AdminModule {}

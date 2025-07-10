import { AdminModule } from 'src/modules/admin/admin.module';
import { CategoriesAdminModule } from 'src/modules/admin/categories/categories.module';

export const adminRoutes = [
  {
    path: 'admin',
    module: AdminModule,
    children: [CategoriesAdminModule],
  },
];

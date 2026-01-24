import { AdminModule } from 'src/modules/admin/admin.module';
import { CategoriesAdminModule } from 'src/modules/admin/categories/categories.module';
import { MultisiteAdminModule } from 'src/modules/admin/multisite/multisite.module';
import { SettingsAdminModule } from 'src/modules/admin/settings/settings.module';

export const adminRoutes = [
  {
    path: 'admin',
    module: AdminModule,
    children: [CategoriesAdminModule, MultisiteAdminModule, SettingsAdminModule],
  },
];

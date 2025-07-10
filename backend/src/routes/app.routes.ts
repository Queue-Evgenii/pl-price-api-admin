import { AppModule } from 'src/app.module';
import { adminRoutes } from './admin.routes';
import { authRoutes } from './auth.routes';
import { categoriesRoutes } from './categories.routes';

export const routes = [
  {
    path: 'api',
    module: AppModule,
    children: [...adminRoutes, ...authRoutes, ...categoriesRoutes],
  },
];

import { AppModule } from 'src/app.module';
import { adminRoutes } from './admin.routes';
import { authRoutes } from './auth.routes';

export const routes = [
  {
    path: 'api',
    module: AppModule,
    children: [...adminRoutes, ...authRoutes],
  },
];

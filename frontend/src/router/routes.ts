import { adminRoutes } from './routes/admin.routes';
import { authRoutes } from './routes/auth.routes';
import { commonRoutes } from './routes/common.routes';

export const routes = [
  ...commonRoutes,
  ...adminRoutes,
  ...authRoutes,
]
import { adminRoutes } from './routes/admin.routes';
import { authRoutes } from './routes/auth.routes';
import { siteRoutes } from './routes/site.routes';

export const routes = [
  ...siteRoutes,
  ...adminRoutes,
  ...authRoutes,
]
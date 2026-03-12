import { Capacitor } from '@capacitor/core';
import { adminRoutes } from './routes/admin.routes';
import { authRoutes } from './routes/auth.routes';
import { siteRoutes } from './routes/site.routes';

export const routes = [
  ...(Capacitor.isNativePlatform() ? [] : adminRoutes),
  ...siteRoutes,
  ...(Capacitor.isNativePlatform() ? [] : authRoutes),
]
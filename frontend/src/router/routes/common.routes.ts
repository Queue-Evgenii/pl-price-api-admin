import { RouteName } from '@/types/constants/route-name';

export const commonRoutes = [
  {
    path: '/',
    redirect: { name: RouteName.AUTH.ROOT },
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: { name: RouteName.NOT_FOUND },
  },
  {
    path: '/not-found',
    name: RouteName.NOT_FOUND,
    component: () => import('@/views/common/not-found.vue'),
  },
  {
    path: '/forbidden',
    name: RouteName.FORBIDDEN,
    component: () => import('@/views/common/forbidden.vue'),
  },
]
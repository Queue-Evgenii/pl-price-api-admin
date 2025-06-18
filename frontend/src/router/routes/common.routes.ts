import { RouteName } from '@/constants/route-name';

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
]
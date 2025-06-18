import { RouteName } from '@/types/constants/route-name';

export const adminRoutes = [
  {
    path: '/admin',
    component: () => import('@/views/admin/index.vue'),
    children: [
      {
        path: '',
        name: RouteName.ADMIN.ROOT,
        redirect: { name: RouteName.ADMIN.CATEGORIES }
      },
      {
        path: 'categories',
        name: RouteName.ADMIN.CATEGORIES,
        component: () => import('@/views/admin/categories.vue')
      },
    ], 
  },
]
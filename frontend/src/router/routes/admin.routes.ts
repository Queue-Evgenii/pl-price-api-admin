import { RouteName } from '@/constants/route-name';

export const adminRoutes = [
  {
    path: '/admin',
    component: () => import('@/views/admin/index.vue'),
    children: [
      {
        path: '',
        name: RouteName.ADMIN.ROOT,
        redirect: { name: RouteName.ADMIN.CATALOGUE }
      },
      {
        path: 'categories',
        name: RouteName.ADMIN.CATALOGUE,
        component: () => import('@/views/admin/categories.vue')
      },
    ], 
  },
]
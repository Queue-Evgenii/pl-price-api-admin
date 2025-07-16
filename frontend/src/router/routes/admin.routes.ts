import { RouteName } from '@/types/constants/route-name';

export const adminRoutes = [
  {
    path: '/admin',
    component: () => import('@/views/admin/index.vue'),
    meta: {
      requiresAuth: true,
      requiresAdmin: true,
      breadcrumb: 'Admin-panel',
    },
    children: [
      {
        path: '',
        name: RouteName.ADMIN.ROOT,
        redirect: { name: RouteName.ADMIN.CATEGORIES.ROOT },
      },
      {
        path: 'categories',
        component: () => import('@/views/admin/categories/index.vue'),
        meta: {
          breadcrumb: 'Categories',
        },
        children: [
          {
            path: '',
            name: RouteName.ADMIN.CATEGORIES.ROOT,
            component: () => import('@/views/admin/categories/categories.vue'),
          },
          {
            path: ':id/photos',
            name: RouteName.ADMIN.CATEGORIES.PHOTOS,
            component: () => import('@/views/admin/categories/photos.vue'),
            props: (route: any) => ({ categoryId: Number(route.params.id) }),
            meta: {
              breadcrumb: (route: any) => `#${route.params.id}`,
            },
          },
        ],
      },
      
    ],
  },
];

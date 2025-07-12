import { RouteName } from '@/types/constants/route-name';
import type { RouteLocationNormalizedLoadedGeneric as VueRoute } from 'vue-router';

export const adminRoutes = [
  {
    path: '/admin',
    component: () => import('@/views/admin/index.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
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
      {
        path: 'categories/:id/photos',
        name: RouteName.ADMIN.CATEGORY_PHOTOS,
        component: () => import('@/views/admin/photos.vue'),
        props: (route: VueRoute) => ({ categoryId: Number(route.params.id) })
      },
    ], 
  },
]
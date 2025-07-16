import { RouteName } from '@/types/constants/route-name';
import { commonRoutes } from './common.routes';

export const siteRoutes = [
  {
    path: '/',
    meta: {
      breadcrumb: 'Home',
    },
    children: [
      ...commonRoutes,
      {
        path: '',
        name: RouteName.SITE.ROOT,
        redirect: { name: RouteName.SITE.CATEGORIES.ROOT },
      },
      {
        path: 'categories',
        component: () => import('@/views/site/categories/index.vue'),
        meta: {
          breadcrumb: 'Categories',
        },
        children: [
          {
            path: '',
            name: RouteName.SITE.CATEGORIES.ROOT,
            component: () => import('@/views/site/categories/categories.vue'),
            props: (route: any) => ({ categoryId: Number(route.params.id) }),
          },
          {
            path: ':id',
            name: RouteName.SITE.CATEGORIES.DETAIL,
            component: () => import('@/views/site/categories/categories.vue'),
            props: (route: any) => ({ categoryId: Number(route.params.id) }),
            meta: {
              breadcrumb: (route: any) => `#${route.params.id}`,
            },
          },
        ]
      },
      
    ],
  },
];

import { RouteName } from '@/types/constants/route-name';
import { commonRoutes } from './common.routes';

export const siteRoutes = [
  {
    path: '/',
    component: () => import('@/views/site/index.vue'),
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
          },
          {
            path: ':slug',
            name: RouteName.SITE.CATEGORIES.SLUG,
            component: () => import('@/views/site/categories/categories.vue'),
            props: (route: any) => ({ slug: route.params.slug }),
            meta: {
              breadcrumb: (route: any) => `${route.params.slug}`,
            },
          },
          {
            path: ':slug/photo',
            name: RouteName.SITE.CATEGORIES.DETAIL,
            component: () => import('@/views/site/categories/detail.vue'),
            props: (route: any) => ({ slug: route.params.slug }),
            meta: {
              breadcrumb: (route: any) => `${route.params.slug}`,
            },
          },
        ]
      },
      
    ],
  },
];

import { RouteName } from '@/types/constants/route-name';
import { commonRoutes } from './common.routes';
import { useSitesStore } from '@/stores/sites';
import type { NavigationGuardNext, RouteLocationNormalized } from 'vue-router';
import type { SiteEntity } from '@/types/models/entities/site.entity';

const DEFAULT_LANG = 'pl';
const FALLBACK_SITES = [
  { id: 1, code: 'pl', name: 'PL', active: true },
];

function langGuard(to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) {
  const lang = Array.isArray(to.params.lang) ? to.params.lang[0] : to.params.lang;
  const sitesStore = useSitesStore();

  if (sitesStore.sites.length === 0) {
    sitesStore.setSites(FALLBACK_SITES);
  }

  if (!sitesStore.sites.find((el: SiteEntity) => el.code === lang)) {
    if (lang === 'categories' || lang === '') return next({ path: `/${DEFAULT_LANG}/categories` })
    return next({ name: RouteName.NOT_FOUND })
  }

  next()
}

export const siteRoutes = [
  {
    path: '',
    redirect: { path: `${DEFAULT_LANG}/planner`  },
  },
  ...commonRoutes,
  {
    path: '/:lang',
    beforeEnter: langGuard,
    component: () => import('@/views/site/index.vue'),
    meta: {
      breadcrumb: 'Home',
    },
    children: [
      {
        path: '',
        name: RouteName.SITE.ROOT,
        redirect: { name: RouteName.SITE.PLANNER },
      },
      {
        path: 'planner',
        name: RouteName.SITE.PLANNER,
        component: () => import('@/views/site/ceiling-builder.vue'),
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

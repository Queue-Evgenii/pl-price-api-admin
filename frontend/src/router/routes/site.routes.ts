import { RouteName } from '@/types/constants/route-name';
import { commonRoutes } from './common.routes';
import { useSitesStore } from '@/stores/sites';
import type { NavigationGuardNext, RouteLocationNormalized } from 'vue-router';
import type { SiteEntity } from '@/types/models/entities/site.entity';
import { withErrorHandling } from '@/api/api-error-handler';
import type { SitesApi } from '@/api/modules/sites';
import { inject } from 'vue';

const DEFAULT_LANG = 'pl';

async function langGuard(to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) {
  const { lang } = to.params
  const sitesStore = useSitesStore();
  const sitesApi = inject<SitesApi>('SitesApi')!;

  await withErrorHandling(sitesApi.getAll())
    .then(res => {
      res = res.filter(el => el.active == true);
      sitesStore.setSites(res);
    })

  if (!sitesStore.sites.find((el: SiteEntity) => el.code === lang)) {
    if (lang === 'categories') return next({ path: `${DEFAULT_LANG}/categories` })
    return next({ name: RouteName.NOT_FOUND })
  }

  next()
}

export const siteRoutes = [
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

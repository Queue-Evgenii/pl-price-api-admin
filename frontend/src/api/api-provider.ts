import { type App } from 'vue';
import axios from 'axios';
import { AuthApi } from './modules/auth';
import { CategoriesAdminApi, CategoriesApi } from './modules/categories';
import { Token } from '@/types/models/utils/browser/token';
import { SitesApi } from './modules/sites';
import { Site } from '@/types/models/utils/browser/site';
import { type Router } from 'vue-router';
import { SettingsAdminApi, SettingsApi } from './modules/settings';

export function useApiProvider(app: App, router: Router) {
  const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_URL + '/api',
    timeout: 10000,
    headers: {
      'ContentType': 'application/json',
      'Accept': 'application/json',
    },
  });
  apiClient.interceptors.request.use((config) => {
    if (Token.exists()) {
      config.headers.Authorization = `Bearer ${Token.get()}`;
    }
    const lang = router.currentRoute.value.params.lang ?? (Site.exists() ? Site.get() : 'pl');
    config.headers['Content-Language'] = lang;
    return config;
  });

  app.provide('AuthApi', new AuthApi(apiClient));
  app.provide('SettingsAdminApi', new SettingsAdminApi(apiClient));
  app.provide('SettingsApi', new SettingsApi(apiClient));
  app.provide('CategoriesAdminApi', new CategoriesAdminApi(apiClient));
  app.provide('CategoriesApi', new CategoriesApi(apiClient));
  app.provide('SitesApi', new SitesApi(apiClient));
}

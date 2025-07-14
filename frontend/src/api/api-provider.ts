import { type App } from 'vue';
import axios from 'axios';
import { AuthApi } from './modules/auth';
import { CategoriesApi } from './modules/categories';
import { Token } from '@/types/models/utils/browser/token';

export function useApiProvider(app: App) {
  const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_URL,
    timeout: 10000,
    headers: {
      ContentType: 'application/json',
      Accept: 'application/json',
    },
  });
  apiClient.interceptors.request.use((config) => {
    if (Token.exists()) {
      config.headers.Authorization = `Bearer ${Token.get()}`;
    }
    return config;
  });

  app.provide('AuthApi', new AuthApi(apiClient));
  app.provide('CategoriesApi', new CategoriesApi(apiClient));
}

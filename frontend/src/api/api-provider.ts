import { type App } from 'vue';
import axios from 'axios';
import { Token } from '@/types/models/utils/Token';
import { AuthApi } from './modules/auth';
import { CategoriesApi } from './modules/categories';

export function useApiProvider(app: App) {
  const apiClient = axios.create({
    baseURL: 'http://localhost:3000/api',
    timeout: 1000,
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

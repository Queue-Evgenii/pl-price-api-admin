import type { HttpError } from '@/models/utils/browser/http/HttpError';
import { Token } from '@/models/utils/browser/Token';
import router from '@/router';

export const withErrorHandling = <T>(apiCall: Promise<T>): Promise<T> => {
  return apiCall.catch((err: HttpError) => {
    switch (err.status) {
      case 401:
        Token.remove();
        router.push({ name: 'auth' });
        break;
      case 400:
        router.push({ name: 'auth' });
        break;
      case 500:
        router.push({ name: 'server-error' });
        break;
      default:
        break;
    }
    console.log('API Error', err);
    throw err;
  });
};

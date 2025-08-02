import { router } from "@/router";
import { RouteName } from "@/types/constants/route-name";
import type { HttpError } from "@/types/models/utils/browser/http-error";
import { Token } from "@/types/models/utils/browser/token";


export const withErrorHandling = <T>(apiCall: Promise<T>): Promise<T> => {
  return apiCall.catch((err: HttpError) => {
    switch (err.status) {
      case 401:
        Token.remove();
        if (router.currentRoute.value.path.startsWith('/admin/')) {
          router.push({ name: RouteName.AUTH.SIGN_IN });
        }
        break;
      case 403:
        router.push({ name: RouteName.FORBIDDEN });
        break;
      default:
        break;
    }
    console.log('API Error', err);
    throw err;
  });
};
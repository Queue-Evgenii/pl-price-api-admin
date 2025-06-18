import { RouteName } from '@/types/constants/route-name';

export const authRoutes = [
  {
    path: '/auth',
    component: () => import('@/views/auth/index.vue'),
    children: [
      {
        path: '',
        name: RouteName.AUTH.ROOT,
        redirect: { name: RouteName.AUTH.SIGN_IN }
      },
      {
        path: 'sign-in',
        name: RouteName.AUTH.SIGN_IN,
        component: () => import('@/views/auth/sign-in.vue')
      },
    ], 
  },
]
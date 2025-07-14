import { RouteName } from "@/types/constants/route-name"
import { UserRoles } from "@/types/models/entities/user.entity"
import { useUserStore } from "@/stores/user"

import type { RouteLocationNormalized, NavigationGuardNext } from "vue-router"

export const beforeEach = ((to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) => {
  const userStore = useUserStore();

  if (to.name === RouteName.AUTH.SIGN_IN && userStore.user !== undefined) {
    console.log(from.name)
    return next({ name: from.name });
  }

  if (to.meta.requiresAuth && userStore.user === undefined) {
    return next({ name: RouteName.AUTH.SIGN_IN })
  }

  if (to.meta.requiresAdmin && userStore.user !== undefined && userStore.userRole !== UserRoles.ADMIN) {
    return next({ name: RouteName.FORBIDDEN })
  }

  next()
})

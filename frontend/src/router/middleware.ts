import { RouteName } from "@/types/constants/route-name"
import { UserRoles } from "@/types/models/entities/user.entity"
import { useUserStore } from "@/stores/user"

import type { RouteLocationNormalized, NavigationGuardNext } from "vue-router"
import { Token } from "@/types/models/utils/Token"

export const beforeEach = ((to: RouteLocationNormalized, _ : unknown, next: NavigationGuardNext) => {
  const userStore = useUserStore();

  if (to.meta.requiresAuth && !Token.exists()) {
    return next({ name: RouteName.AUTH.SIGN_IN })
  }

  if (to.meta.requiresAdmin && userStore.user !== undefined && userStore.userRole !== UserRoles.ADMIN) {
    return next({ name: RouteName.FORBIDDEN })
  }

  next()
})

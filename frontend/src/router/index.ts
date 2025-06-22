import { createWebHashHistory, createRouter } from 'vue-router'
import { routes } from './routes'
import { beforeEach } from './middleware'

export const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

router.beforeEach(beforeEach)
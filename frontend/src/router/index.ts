import { createWebHashHistory, createRouter } from 'vue-router'
import { routes } from './routes'

export const router = createRouter({
  history: createWebHashHistory(),
  routes,
})
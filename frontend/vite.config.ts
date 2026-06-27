import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

import { fileURLToPath, URL } from 'node:url'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  return {
    base: './',
    plugins: [vue()],
    optimizeDeps: {
      entries: ['index.html'],
    },
    build: {
      chunkSizeWarningLimit: 1300,
      rollupOptions: {
        output: {
          manualChunks: (id) => {
            if (!id.includes('node_modules')) {
              return
            }

            if (id.includes('/node_modules/naive-ui/') || id.includes('/node_modules/vueuc/')) {
              return 'ui'
            }

            if (id.includes('/node_modules/@vicons/')) {
              return 'icons'
            }

            if (id.includes('/node_modules/vue/') || id.includes('/node_modules/vue-router/') || id.includes('/node_modules/pinia/')) {
              return 'vue-vendor'
            }

            return 'vendor'
          },
          assetFileNames: (assetInfo) => {
            const info = assetInfo.name.split('.')
            const ext = info[info.length - 1]
            if (/\.(css|scss)$/.test(assetInfo.name)) {
              return `assets/[name]-[hash][extname]`
            }
            return `assets/[name]-[hash][extname]`
          }
        }
      }
    },
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      },
    },
  }
})

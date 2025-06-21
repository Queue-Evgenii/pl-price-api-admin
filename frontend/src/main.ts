import { createApp } from 'vue'
import './style.css'
import app from './app.vue'
import { router } from './router'
import naive from 'naive-ui'
import { useApiProvider } from './api/api-provider'

const instance = createApp(app);
instance.use(router);

instance.use(naive);

useApiProvider(instance);

instance.mount('#app');
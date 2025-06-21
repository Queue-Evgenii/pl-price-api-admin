import { createApp } from 'vue'
import './style.css'
import app from './app.vue'
import { router } from './router'
import naive from 'naive-ui'
import { useApiProvider } from './api/api-provider'

const application = createApp(app);
application.use(router);

application.use(naive);

useApiProvider(application);

application.mount('#app');
import { createApp } from 'vue'
import './style.css'
import App from './app.vue'
import { router } from './router'
import naive from 'naive-ui'
import { useApiProvider } from './api/api-provider'

const app = createApp(App);
app.use(router);

app.use(naive);

useApiProvider(app);

app.mount('#app');
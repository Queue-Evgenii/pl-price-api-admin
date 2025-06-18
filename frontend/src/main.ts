import { createApp } from 'vue'
import './style.css'
import App from './app.vue'
import { router } from './router'
import naive from 'naive-ui'

createApp(App).use(router).use(naive).mount('#app');

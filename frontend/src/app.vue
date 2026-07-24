<script setup lang="ts">
import { inject, watch } from 'vue';
import { RouterView, useRoute, useRouter } from 'vue-router';
import type { AuthApi } from './api/modules/auth';
import { useUserStore } from './stores/user';
import { RouteName } from './types/constants/route-name';
import { Token } from './types/models/utils/browser/token';
import { Capacitor } from '@capacitor/core';

const userStore = useUserStore();
const authApi = inject<AuthApi>('AuthApi')!;
const router = useRouter();
const route = useRoute();

const themeOverrides = {
  common: {
    warningColor: 'rgb(240, 160, 32)'
  },
}

let didBootstrapAuth = false;

watch(
  () => route.path,
  path => {
    const isAdminSurface = path.startsWith('/admin') || path.startsWith('/auth');
    if (Capacitor.isNativePlatform() || !isAdminSurface || didBootstrapAuth) return;

    didBootstrapAuth = true;
    authApi.getMe()
      .then(res => {
        Token.set(res.token);
        userStore.setUser(res.user);

        if (route.path.startsWith('/auth')) {
          router.push({ name: RouteName.ADMIN.ROOT });
        }
      });
  },
  { immediate: true },
);
</script>

<template>
  <n-config-provider :theme-overrides="themeOverrides">
    <n-message-provider placement="bottom">
      <router-view />
    </n-message-provider>
  </n-config-provider>
</template>

<style>
#app {
  height: 100%;
}
.n-config-provider {
  height: 100%;
}
.page {
  background: url('./assets/background.jpg') center / cover no-repeat;
}
</style>

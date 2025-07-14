<script setup lang="ts">
import { inject } from 'vue';
import { RouterView, useRoute, useRouter } from 'vue-router';
import type { AuthApi } from './api/modules/auth';
import { useUserStore } from './stores/user';
import { RouteName } from './types/constants/route-name';
import { Token } from './types/models/utils/browser/token';

const userStore = useUserStore();
const authApi = inject<AuthApi>('AuthApi')!;
const router = useRouter();
const route = useRoute();

authApi.getMe()
  .then(res => {
    Token.set(res.token);
    userStore.setUser(res.user);

    if (route.path.startsWith('/auth') && !route.path.startsWith('path')) {
      router.push({ name: RouteName.ADMIN.ROOT });
    }
  })

</script>

<template>
  <n-config-provider>
    <n-message-provider placement="bottom">
      <router-view />
    </n-message-provider>
  </n-config-provider>
</template>

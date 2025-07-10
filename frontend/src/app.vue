<script setup lang="ts">
import { inject } from 'vue';
import { RouterView, useRouter } from 'vue-router';
import type { AuthApi } from './api/modules/auth';
import { useUserStore } from './stores/user';
import { Token } from './types/models/utils/Token';
import { RouteName } from './types/constants/route-name';

const userStore = useUserStore();
const authApi = inject<AuthApi>('AuthApi')!;
const router = useRouter();

authApi.getMe()
  .then(res => {
    Token.set(res.token);
    userStore.setUser(res.user);
    router.push({ name: RouteName.ADMIN.ROOT })
  })

</script>

<template>
  <n-config-provider>
    <n-message-provider placement="bottom">
      <router-view />
    </n-message-provider>
  </n-config-provider>
</template>

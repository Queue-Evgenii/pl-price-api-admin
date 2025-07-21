<script setup lang="ts">
import { useUserStore } from '@/stores/user';
import { RouteName } from '@/types/constants/route-name';
import { UserRoles } from '@/types/models/entities/user.entity';
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';


const userStore = useUserStore();
const router = useRouter();
onMounted(() => {
  if (userStore.user === undefined) {
    return router.push({ name: RouteName.AUTH.SIGN_IN });
  }
  if (userStore.userRole !== UserRoles.ADMIN){
    return router.push({ name: RouteName.FORBIDDEN });
  }
    
})
</script>

<template>
  <router-view />
</template>
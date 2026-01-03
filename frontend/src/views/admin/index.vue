<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { SitesApi } from '@/api/modules/sites';
import AdminLayout from '@/layouts/admin-layout.vue';
import { useSitesStore } from '@/stores/sites';
import { useUserStore } from '@/stores/user';
import { RouteName } from '@/types/constants/route-name';
import { UserRoles } from '@/types/models/entities/user.entity';
import { Site } from '@/types/models/utils/browser/site';
import { inject, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const userStore = useUserStore();
const router = useRouter();
const sitesStore = useSitesStore();
const sitesApi = inject<SitesApi>('SitesApi')!;

withErrorHandling(sitesApi.getAll())
  .then(res => {
    sitesStore.setSites(res);
    sitesStore.setSite(Site.exists() ? Site.get() : 'pl');
  })

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
  <admin-layout>
    <router-view />
  </admin-layout>
</template>
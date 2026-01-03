<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { SitesApi } from '@/api/modules/sites';
import { useSitesStore } from '@/stores/sites';
import { Site } from '@/types/models/utils/browser/site';
import { inject } from 'vue';

const sitesStore = useSitesStore();
const sitesApi = inject<SitesApi>('SitesApi')!;

const init = async () => {
  if (!sitesStore.sites || sitesStore.sites.length === 0) {
    await withErrorHandling(sitesApi.getAll())
      .then(res => {
        res = res.filter(el => el.active == true);
        sitesStore.setSites(res);
      })
  }

  if (Site.exists()) {
    const exists = sitesStore.sites.find(el => el.code === Site.get());
    sitesStore.setSite(exists ? Site.get() : 'pl');
  } else {
    sitesStore.setSite('pl');
  }
}
init();
</script>

<template>
  <router-view />
</template>
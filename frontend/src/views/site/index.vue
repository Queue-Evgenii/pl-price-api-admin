<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { SitesApi } from '@/api/modules/sites';
import type { SettingsApi } from '@/api/modules/settings';
import { useSitesStore } from '@/stores/sites';
import { useSettingsStore } from '@/stores/settings';
import { Site } from '@/types/models/utils/browser/site';
import { Capacitor } from '@capacitor/core';
import { inject } from 'vue';
import CookieBanner from '@/components/cookie-banner.vue';

const sitesStore = useSitesStore();
const settingsStore = useSettingsStore();
const sitesApi = inject<SitesApi>('SitesApi')!;
const settingsApi = inject<SettingsApi>('SettingsApi')!;

const isNative = Capacitor.isNativePlatform();

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

  if (!settingsStore.settings) {
    const settings = await withErrorHandling(settingsApi.getSettings());
    settingsStore.setSettings(settings);
  }
}
init();
</script>

<template>
  <router-view />
  <CookieBanner v-if="!isNative" />
</template>

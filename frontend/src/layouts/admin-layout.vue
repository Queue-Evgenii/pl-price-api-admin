<script  setup lang="ts">
import { computed, h, inject, nextTick, onMounted, ref, watch } from 'vue';
import breadcrumbs from '../components/breadcrumbs.vue';
import { Token } from '@/types/models/utils/browser/token';
import { useUserStore } from '@/stores/user';
import { useRoute, useRouter } from 'vue-router';
import { RouteName } from '@/types/constants/route-name';
import { CategoryFilled, HomeFilled, LanguageFilled, LogOutFilled, SettingsApplicationsOutlined, WarningFilled } from '@vicons/material'
import { useThemeVars } from 'naive-ui';
import { useSitesStore, type SiteOpt } from '@/stores/sites';
import { Site } from '@/types/models/utils/browser/site';
import type { CategoriesAdminApi } from '@/api/modules/categories';
import { useCategoriesStore } from '@/stores/categories';
import { withErrorHandling } from '@/api/api-error-handler';

const isConfirmationVisible = ref(false);
const store = useUserStore();
const sitesStore = useSitesStore();
const CategoriesAdminApi = inject<CategoriesAdminApi>('CategoriesAdminApi')!;
const categoriesStore = useCategoriesStore();
const router = useRouter();
const route = useRoute();
const themeVars = useThemeVars();

const curSiteOpt = ref<string>();

const logout = () => {
  store.clearState();
  Token.remove();

  isConfirmationVisible.value = false;

  router.push({ name: RouteName.AUTH.SIGN_IN })
}

const openLogoutDialog = () => {
  isConfirmationVisible.value = true;
}

const fetchCategories = async () => {
  const { data } = (await withErrorHandling(CategoriesAdminApi.getCategories({ page: 1, limit: 10 })));
  categoriesStore.setCategories(data);
}

const changeSite = (newOptValue: string) => {
  sitesStore.setSite(newOptValue);
  fetchCategories();
}

const menuItems = [
    {
        label: "Categories",
        key: RouteName.ADMIN.CATEGORIES.ROOT,
        icon: CategoryFilled,
    },
    {
        label: "General",
        key: RouteName.ADMIN.SETTINGS.ROOT,
        icon: SettingsApplicationsOutlined,
    },
    {
        label: "Sites",
        key: RouteName.ADMIN.SITES.ROOT,
        icon: LanguageFilled,
    },
];

const handleMenuSelect = (key: string) => {
    router.push({ name: key });
};

const selectedKey = computed(() => route.name);
</script>

<template>
  <div>
    <n-space vertical style="max-width: 1920px; margin: 0 auto; padding: 16px 24px;">
      <n-flex :align="'center'" justify="space-between">
        <n-flex :align="'center'" >
          <img
            height="50"
            src="../assets/logo.png"
          />
          <breadcrumbs />
        </n-flex>
        <n-flex :align="'center'" :justify="'end'" style="flex: 1 0 auto; flex-flow: nowrap;">
          <router-link :to="{ name: RouteName.SITE.ROOT, params: { lang: 'pl' } }">
            <n-button>
              <template #icon>
                <HomeFilled style="vertical-align: middle; transform: translateY(1px);" />
              </template>
              Site
            </n-button>
          </router-link>
          <div style="flex: 0 0 130px;">
            <n-select :value="sitesStore.curOpt.value" :options="sitesStore.opts" @update:value="changeSite" />
          </div>
          <n-button @click="openLogoutDialog">
            <template #icon>
              <LogOutFilled style="vertical-align: middle; transform: translateY(1px);" />
            </template>
            Log Out
          </n-button>
        </n-flex>
      </n-flex>
    </n-space>
    <n-layout has-sider style="flex:1 1 100%; position: relative;">
      <n-layout-sider
          bordered
          width="220"
      >
          <n-menu
              :options="menuItems.map(i => ({
                  label: i.label,
                  key: i.key,
                  icon: () => h(i.icon),
              }))"
              :value="selectedKey"
              @update:value="handleMenuSelect"
              :collapsed-width="64"
          />
      </n-layout-sider>

        <n-layout-content class="_container">
            <slot></slot>
        </n-layout-content>
    </n-layout>
  </div>
  
  <n-modal v-model:show="isConfirmationVisible" title="Log Out" preset="dialog">
    <template #icon>
      <WarningFilled :style="{ color: themeVars.warningColor }" />
    </template>
    <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 16px;">
      <p>Are you sure?</p>
      <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
        <n-button @click="isConfirmationVisible = false">Cancel</n-button>
        <n-button type="warning" @click="logout">Log Out</n-button>
      </div>
    </div>
  </n-modal>
</template>

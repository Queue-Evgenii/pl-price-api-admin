<script  setup lang="ts">
import { ref } from 'vue';
import breadcrumbs from '../components/breadcrumbs.vue';
import { Token } from '@/types/models/utils/browser/token';
import { useUserStore } from '@/stores/user';
import { useRouter } from 'vue-router';
import { RouteName } from '@/types/constants/route-name';
import { LogOutFilled, WarningFilled } from '@vicons/material'
import { useThemeVars } from 'naive-ui';

const isConfirmationVisible = ref(false);
const store = useUserStore();
const router = useRouter();
const themeVars = useThemeVars();

const logout = () => {
  store.clearState();
  Token.remove();

  isConfirmationVisible.value = false;

  router.push({ name: RouteName.AUTH.SIGN_IN })
}

const openLogoutDialog = () => {
  isConfirmationVisible.value = true;
}
</script>

<template>
  <div>
    <n-space vertical style="max-width: 1920px; margin: 0 auto; padding: 16px 24px;">
      <n-flex :align="'center'" justify="space-between">
        <n-flex :align="'center'" >
          <n-image
            height="50"
            src="logo.png"
          />
          <breadcrumbs />
        </n-flex>
        <n-button @click="openLogoutDialog">
          <template #icon>
            <LogOutFilled style="vertical-align: middle; transform: translateY(1px);" />
          </template>
          Log Out
        </n-button>
      </n-flex>
    </n-space>
    <slot></slot>
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

<script setup lang="ts">
import { ListAltFilled } from '@vicons/material';
import { computed } from 'vue';
import { useEstimateStore } from '@/stores/estimate';

defineProps<{
  text?: string;
}>();

const emit = defineEmits<{
  open: [];
}>();

const estimateStore = useEstimateStore();
const count = computed(() => estimateStore.count);
</script>

<template>
  <n-badge :value="count" :show="count > 0" :max="99">
    <n-button size="small" secondary @click="emit('open')">
      <template #icon>
        <n-icon>
          <ListAltFilled />
        </n-icon>
      </template>
      {{ text ?? 'Material estimate' }}
    </n-button>
  </n-badge>
</template>

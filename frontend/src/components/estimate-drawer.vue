<script setup lang="ts">
import { computed, ref } from 'vue';
import { useMessage } from 'naive-ui';
import { DeleteFilled, ContentCopyFilled, ShareFilled } from '@vicons/material';
import { useEstimateStore } from '@/stores/estimate';
import type { EstimateItem } from '@/types/models/estimate-item';

defineProps<{
  show: boolean;
}>();

const emit = defineEmits<{
  'update:show': [value: boolean];
}>();

const estimateStore = useEstimateStore();
const message = useMessage();
const fallbackTextVisible = ref(false);

const unitOptions = [
  { label: 'pcs', value: 'pcs' },
  { label: 'm²', value: 'm²' },
  { label: 'mb', value: 'mb' },
];

const total = computed(() => estimateStore.total.toFixed(2));
const exportText = computed(() => estimateStore.exportText());

const close = () => emit('update:show', false);

const updateNumber = (item: EstimateItem, field: 'quantity' | 'unitPrice', value: number | null) => {
  estimateStore.updateItem(item.id, { [field]: value ?? 0 });
};

const stepNumber = (item: EstimateItem, field: 'quantity' | 'unitPrice', step: number) => {
  const nextValue = Math.max(0, item[field] + step);
  estimateStore.updateItem(item.id, { [field]: nextValue });
};

const shareEstimate = async () => {
  const text = exportText.value;

  try {
    if (navigator.share) {
      await navigator.share({ title: 'Material estimate', text });
      return;
    }

    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text);
      message.success('Estimate copied');
      return;
    }
  } catch {
    message.warning('Share was not completed');
    return;
  }

  fallbackTextVisible.value = true;
};
</script>

<template>
  <n-drawer :show="show" placement="bottom" height="82%" @update:show="emit('update:show', $event)">
    <n-drawer-content title="Material estimate" closable @close="close">
      <template #header-extra>
        <n-space>
          <n-button size="small" secondary :disabled="estimateStore.count === 0" @click="shareEstimate">
            <template #icon>
              <n-icon>
                <ShareFilled />
              </n-icon>
            </template>
            Share
          </n-button>
          <n-popconfirm
            positive-text="Clear"
            negative-text="Cancel"
            :disabled="estimateStore.count === 0"
            @positive-click="estimateStore.clear"
          >
            <template #trigger>
              <n-button size="small" secondary type="error" :disabled="estimateStore.count === 0">
                Clear
              </n-button>
            </template>
            Clear the estimate?
          </n-popconfirm>
        </n-space>
      </template>

      <n-empty
        v-if="estimateStore.count === 0"
        description="Add materials from the catalog to calculate a local estimate. Items are saved on this iPhone."
      />

      <div v-else class="estimate-list">
        <div v-for="item in estimateStore.items" :key="item.id" class="estimate-item">
          <div class="estimate-item__top">
            <div class="estimate-item__title">{{ item.title }}</div>
            <n-popconfirm positive-text="Delete" negative-text="Cancel" @positive-click="estimateStore.deleteItem(item.id)">
              <template #trigger>
                <n-button quaternary circle type="error" aria-label="Delete item">
                  <template #icon>
                    <n-icon>
                      <DeleteFilled />
                    </n-icon>
                  </template>
                </n-button>
              </template>
              Delete this item?
            </n-popconfirm>
          </div>

          <div class="estimate-item__meta">
            {{ item.categorySlug }}<span v-if="item.photoId"> · photo #{{ item.photoId }}</span>
          </div>

          <div class="estimate-item__controls">
            <div class="estimate-stepper">
              <n-button
                class="estimate-stepper__button"
                size="small"
                secondary
                :disabled="item.quantity <= 0"
                aria-label="Decrease quantity"
                @pointerdown.prevent
                @click="stepNumber(item, 'quantity', -1)"
              >
                -
              </n-button>
              <n-input-number
                :value="item.quantity"
                :min="0"
                :step="1"
                :show-button="false"
                size="small"
                placeholder="Qty"
                @update:value="updateNumber(item, 'quantity', $event)"
              />
              <n-button
                class="estimate-stepper__button"
                size="small"
                secondary
                aria-label="Increase quantity"
                @pointerdown.prevent
                @click="stepNumber(item, 'quantity', 1)"
              >
                +
              </n-button>
            </div>
            <div class="estimate-stepper">
              <n-button
                class="estimate-stepper__button"
                size="small"
                secondary
                :disabled="item.unitPrice <= 0"
                aria-label="Decrease unit price"
                @pointerdown.prevent
                @click="stepNumber(item, 'unitPrice', -1)"
              >
                -
              </n-button>
              <n-input-number
                :value="item.unitPrice"
                :min="0"
                :step="1"
                :show-button="false"
                size="small"
                placeholder="Price, zł"
                @update:value="updateNumber(item, 'unitPrice', $event)"
              />
              <n-button
                class="estimate-stepper__button"
                size="small"
                secondary
                aria-label="Increase unit price"
                @pointerdown.prevent
                @click="stepNumber(item, 'unitPrice', 1)"
              >
                +
              </n-button>
            </div>
            <n-select
              :value="item.unit"
              :options="unitOptions"
              size="small"
              @update:value="estimateStore.updateItem(item.id, { unit: $event })"
            />
          </div>

          <div class="estimate-item__subtotal">Subtotal: {{ (item.quantity * item.unitPrice).toFixed(2) }} zł</div>
        </div>
      </div>

      <template #footer>
        <div class="estimate-footer">
          <strong>Total: {{ total }} zł</strong>
          <n-button :disabled="estimateStore.count === 0" secondary @click="shareEstimate">
            <template #icon>
              <n-icon>
                <ContentCopyFilled />
              </n-icon>
            </template>
            Copy
          </n-button>
        </div>
      </template>
    </n-drawer-content>
  </n-drawer>

  <n-modal v-model:show="fallbackTextVisible" preset="card" title="Copy estimate" style="max-width: 640px;">
    <n-input :value="exportText" type="textarea" :autosize="{ minRows: 8, maxRows: 14 }" readonly />
  </n-modal>
</template>

<style scoped>
.estimate-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.estimate-item {
  padding: 12px;
  border: 1px solid rgba(0, 0, 0, 0.14);
  border-radius: 8px;
  background: #fff;
  text-align: left;
}
.estimate-item__top,
.estimate-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.estimate-item__title {
  font-weight: 700;
}
.estimate-item__meta,
.estimate-item__subtotal {
  margin-top: 4px;
  color: rgba(0, 0, 0, 0.58);
  font-size: 12px;
}
.estimate-item__controls {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr) 88px;
  gap: 8px;
  margin-top: 10px;
}
.estimate-stepper {
  display: grid;
  grid-template-columns: 32px minmax(0, 1fr) 32px;
  gap: 4px;
  min-width: 0;
}
.estimate-stepper__button {
  min-width: 32px;
}
.estimate-item__controls :deep(.n-input),
.estimate-item__controls :deep(.n-input-number),
.estimate-item__controls :deep(.n-base-selection),
.estimate-item__controls :deep(.n-base-selection-label),
.estimate-item__controls :deep(.n-input__input),
.estimate-item__controls :deep(.n-input__input-el),
.estimate-item__controls :deep(input) {
  font-size: 16px;
  touch-action: manipulation;
}
.estimate-item__controls :deep(.n-button),
.estimate-item__controls :deep(.n-input-number-button) {
  font-size: 16px;
  touch-action: manipulation;
}
.estimate-footer {
  width: 100%;
}
</style>

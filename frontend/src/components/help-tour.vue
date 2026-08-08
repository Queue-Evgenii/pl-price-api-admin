<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue';

type TourStep = {
  target: string;
  title: string;
  text: string;
  placement?: 'top' | 'bottom';
  actionTarget?: string;
};

const props = defineProps<{
  steps: TourStep[];
  storageKey: string;
}>();

const isOpen = ref(false);
const currentIndex = ref(0);
const targetRect = ref<DOMRect | null>(null);
const viewport = ref({ width: window.innerWidth, height: window.innerHeight });

const currentStep = computed(() => props.steps[currentIndex.value]);
const totalSteps = computed(() => props.steps.length);
const isLastStep = computed(() => currentIndex.value === totalSteps.value - 1);

const focusStyle = computed(() => {
  if (!targetRect.value) return {};

  const padding = 8;
  return {
    top: `${Math.max(targetRect.value.top - padding, 8)}px`,
    left: `${Math.max(targetRect.value.left - padding, 8)}px`,
    width: `${Math.min(targetRect.value.width + padding * 2, viewport.value.width - 16)}px`,
    height: `${targetRect.value.height + padding * 2}px`,
  };
});

const tooltipStyle = computed(() => {
  const verticalInset = 16;
  const cardMinHeight = 190;
  const estimatedCardHeight = Math.min(320, viewport.value.height - verticalInset * 2);
  const maxTop = Math.max(verticalInset, viewport.value.height - estimatedCardHeight - verticalInset);

  if (!targetRect.value) {
    return {
      width: `${Math.min(360, window.innerWidth - 32)}px`,
      minHeight: `${cardMinHeight}px`,
      maxHeight: `calc(100vh - ${verticalInset * 2}px)`,
      left: '16px',
      top: `${Math.min(Math.max(72, verticalInset), maxTop)}px`,
    };
  }

  const tooltipWidth = Math.min(360, viewport.value.width - 32);
  const left = Math.min(
    Math.max(targetRect.value.left + targetRect.value.width / 2 - tooltipWidth / 2, 16),
    viewport.value.width - tooltipWidth - 16,
  );
  const prefersTop = currentStep.value?.placement === 'top';
  const bottomTop = targetRect.value.bottom + 22;
  const topTop = targetRect.value.top - cardMinHeight - 20;
  const unclampedTop = prefersTop || bottomTop > viewport.value.height - cardMinHeight
    ? topTop
    : bottomTop;
  const top = Math.min(Math.max(unclampedTop, verticalInset), maxTop);

  return {
    width: `${tooltipWidth}px`,
    minHeight: `${cardMinHeight}px`,
    maxHeight: `calc(100vh - ${verticalInset * 2}px)`,
    left: `${left}px`,
    top: `${top}px`,
  };
});

const markSeen = () => localStorage.setItem(props.storageKey, 'true');

const findTarget = () => {
  const step = currentStep.value;
  if (!step) return null;
  return document.querySelector<HTMLElement>(step.target);
};

const updateTarget = async () => {
  await nextTick();
  viewport.value = { width: window.innerWidth, height: window.innerHeight };

  const element = findTarget();
  if (!element) {
    targetRect.value = null;
    return;
  }

  element.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'smooth' });
  window.scrollTo({ left: 0, top: window.scrollY, behavior: 'auto' });
  window.setTimeout(() => {
    window.scrollTo({ left: 0, top: window.scrollY, behavior: 'auto' });
    targetRect.value = element.getBoundingClientRect();
  }, 260);
};

const wait = (duration = 360) => new Promise(resolve => window.setTimeout(resolve, duration));

const runStepAction = async () => {
  const selector = currentStep.value?.actionTarget;
  if (!selector) return;

  const element = document.querySelector<HTMLElement>(selector);
  element?.click();
  await wait();
};

const open = async (fromAutoStart = false) => {
  if (!props.steps.length) return;
  if (fromAutoStart && localStorage.getItem(props.storageKey) === 'true') return;

  currentIndex.value = 0;
  isOpen.value = true;
  await updateTarget();
};

const close = () => {
  isOpen.value = false;
  window.scrollTo({ left: 0, top: window.scrollY, behavior: 'auto' });
  markSeen();
};

const next = async () => {
  await runStepAction();

  if (isLastStep.value) {
    close();
    return;
  }

  currentIndex.value += 1;
  await updateTarget();
};

const prev = async () => {
  if (currentIndex.value === 0) return;
  currentIndex.value -= 1;
  await updateTarget();
};

const handleResize = () => {
  if (!isOpen.value) return;
  updateTarget();
};

onMounted(() => {
  window.addEventListener('resize', handleResize);
  window.addEventListener('scroll', handleResize, true);
  window.setTimeout(() => open(true), 700);
});

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize);
  window.removeEventListener('scroll', handleResize, true);
});

defineExpose({ open });
</script>

<template>
  <teleport to="body">
    <div v-if="isOpen && currentStep" class="help-tour" role="dialog" aria-modal="true">
      <div class="help-tour__shade" />
      <div v-if="targetRect" class="help-tour__focus" :style="focusStyle" />
      <section class="help-tour__card" :style="tooltipStyle">
        <div class="help-tour__meta">{{ currentIndex + 1 }} / {{ totalSteps }}</div>
        <h3>{{ currentStep.title }}</h3>
        <p>{{ currentStep.text }}</p>
        <div class="help-tour__actions">
          <n-button secondary @click="close">Przejdź do pracy</n-button>
          <div class="help-tour__step-actions">
            <n-button secondary :disabled="currentIndex === 0" @click="prev">Wstecz</n-button>
            <n-button type="warning" @click="next">
              {{ isLastStep ? 'Gotowe' : 'Dalej' }}
            </n-button>
          </div>
        </div>
      </section>
    </div>
  </teleport>
</template>

<style scoped>
.help-tour {
  position: fixed;
  inset: 0;
  z-index: 5000;
  color: #252525;
  pointer-events: none;
}
.help-tour__shade {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.68);
  pointer-events: none;
}
.help-tour__focus {
  position: fixed;
  border: 3px solid rgb(240, 160, 32);
  border-radius: 10px;
  box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.5), 0 0 24px rgba(240, 160, 32, 0.85);
  pointer-events: none;
  transition: all 0.24s ease;
}
.help-tour__card {
  position: fixed;
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(0, 0, 0, 0.18);
  border-radius: 8px;
  box-shadow: 0 18px 46px rgba(0, 0, 0, 0.28);
  padding: 18px;
  overflow-y: auto;
  text-align: left;
  pointer-events: auto;
}
.help-tour__meta {
  color: rgb(180, 105, 0);
  font-size: 13px;
  font-weight: 700;
  margin-bottom: 6px;
}
.help-tour__card h3 {
  font-size: 20px;
  line-height: 1.2;
  margin: 0 0 8px;
}
.help-tour__card p {
  font-size: 15px;
  line-height: 1.45;
  margin: 0 0 16px;
}
.help-tour__actions,
.help-tour__step-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}
.help-tour__actions {
  position: sticky;
  bottom: -18px;
  margin-top: auto;
  padding-top: 12px;
  padding-bottom: 2px;
  background: rgba(255, 255, 255, 0.96);
  justify-content: space-between;
}
@media (max-width: 600px) {
  .help-tour__card {
    padding: 16px;
  }
  .help-tour__actions {
    align-items: stretch;
    flex-direction: column;
  }
  .help-tour__step-actions {
    justify-content: flex-end;
  }
}
</style>

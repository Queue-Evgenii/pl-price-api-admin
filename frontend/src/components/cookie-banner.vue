<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { useSettingsStore } from '@/stores/settings';

const STORAGE_KEY = 'cookiesAcceptedAt';
const CONSENT_LIFETIME = 180 * 24 * 60 * 60 * 1000; // 6 miesięcy

const settingsStore = useSettingsStore();

const isAccepted = ref(true);

const text = computed(() => settingsStore.settings?.cookieText);
const acceptText = computed(() => settingsStore.settings?.cookieAcceptText || 'OK');
const linkUrl = computed(() => settingsStore.settings?.cookieLinkUrl);
const linkText = computed(() => settingsStore.settings?.cookieLinkText || linkUrl.value);

const isVisible = computed(() => !isAccepted.value && !!text.value);
const isExternalLink = computed(() => /^(https?:)?\/\//.test(linkUrl.value ?? ''));

const isConsentValid = () => {
  const acceptedAt = Number(localStorage.getItem(STORAGE_KEY));
  if (!acceptedAt) return false;
  return Date.now() - acceptedAt < CONSENT_LIFETIME;
};

const accept = () => {
  localStorage.setItem(STORAGE_KEY, String(Date.now()));
  isAccepted.value = true;
};

onMounted(() => {
  isAccepted.value = isConsentValid();
});
</script>

<template>
  <transition name="cookie-fade">
    <div v-if="isVisible" class="cookie-banner">
      <div class="cookie-banner__text">{{ text }}</div>
      <div class="cookie-banner__actions">
        <button class="cookie-banner__accept" @click="accept">{{ acceptText }}</button>
        <a
          v-if="linkUrl && isExternalLink"
          class="cookie-banner__link"
          :href="linkUrl"
          target="_blank"
          rel="noopener"
        >
          {{ linkText }}
        </a>
        <router-link v-else-if="linkUrl" class="cookie-banner__link" :to="linkUrl">
          {{ linkText }}
        </router-link>
      </div>
    </div>
  </transition>
</template>

<style scoped>
.cookie-banner {
  position: fixed;
  right: 30px;
  bottom: 30px;
  z-index: 12;
  display: flex;
  flex-direction: column;
  gap: 25px;
  width: 100%;
  max-width: 480px;
  padding: 30px;
  background-color: #3d3d3d;
  border-radius: 10px;
  box-shadow: 4px 4px 15px rgba(0, 0, 0, 0.3);
}

.cookie-banner__text {
  font-size: 16px;
  line-height: 22px;
  color: #fff;
  text-align: center;
  white-space: pre-line;
}

.cookie-banner__actions {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  flex-wrap: wrap;
}

.cookie-banner__accept {
  min-width: 200px;
  min-height: 50px;
  padding: 16px 5px;
  border: 1px solid transparent;
  border-radius: 8px;
  background-color: #ff0031;
  color: #fff;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.5s ease;
}

.cookie-banner__link {
  font-size: 16px;
  line-height: 22px;
  color: #fff;
}

@media (min-width: 769px) {
  .cookie-banner__link:hover {
    text-decoration: underline;
  }

  .cookie-banner__accept:hover {
    border-color: #ff0031;
    background-color: rgba(255, 0, 49, 0.5);
  }
}

@media (max-width: 630px) {
  .cookie-banner {
    right: 0;
    left: 0;
    bottom: 15px;
    max-width: none;
    padding: 20px;
    gap: 20px;
  }

  .cookie-banner__text {
    font-size: 14px;
    line-height: 20px;
  }

  .cookie-banner__accept {
    min-width: 100%;
  }
}

.cookie-fade-enter-active,
.cookie-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}

.cookie-fade-enter-from,
.cookie-fade-leave-to {
  opacity: 0;
  transform: translateY(20px);
}
</style>

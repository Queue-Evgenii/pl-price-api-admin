<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { SettingsApi } from '@/api/modules/settings';
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import HelpTour from '@/components/help-tour.vue';
import { useSitesStore } from '@/stores/sites';
import { useSettingsStore } from '@/stores/settings';
import { Site } from '@/types/models/utils/browser/site';
import { Capacitor } from '@capacitor/core';
import { inject } from 'vue';
import CookieBanner from '@/components/cookie-banner.vue';

const sitesStore = useSitesStore();
const settingsStore = useSettingsStore();
const settingsApi = inject<SettingsApi>('SettingsApi')!;

const isNative = Capacitor.isNativePlatform();
const route = useRoute();
const helpTour = ref<InstanceType<typeof HelpTour> | null>(null);
const fallbackSites = [
  { id: 1, code: 'pl', name: 'PL', active: true },
];

const init = async () => {
  if (!sitesStore.sites || sitesStore.sites.length === 0) {
    sitesStore.setSites(fallbackSites);
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

const helpSteps = computed(() => {
  const commonFirstStep = {
    target: '[data-tour="help-button"]',
    title: 'Pomoc jest zawsze tutaj',
    text: 'Dotknij znaku zapytania, aby w dowolnym momencie ponownie uruchomić przewodnik po aplikacji.',
  };

  if (route.path.includes('/categories')) {
    return [
      commonFirstStep,
      {
        target: '[data-tour="site-title"]',
        title: 'Główny katalog',
        text: 'Na tym ekranie wybierasz rodzaj sufitu, materiały i kolejne sekcje katalogu Poland Group.',
      },
      {
        target: '[data-tour="category-item"]',
        title: 'Wybierz kategorię',
        text: 'Kliknij kategorię, aby przejść głębiej: zobaczysz podkategorie, zdjęcia i dostępne materiały.',
      },
      {
        target: '[data-tour="planner-button"]',
        title: 'Ceiling planner',
        text: 'Ten przycisk otwiera planer sufitu. Tam możesz przygotować układ i obliczenia dla projektu.',
      },
      {
        target: '[data-tour="download-section"]',
        title: 'Program do pobrania',
        text: 'W tej sekcji znajdziesz wersje programu dla komputera, Androida i Apple, jeśli są dostępne.',
      },
      {
        target: '[data-tour="telegram-link"]',
        title: 'Kontakt i społeczność',
        text: 'Telegram prowadzi do kanału kontaktowego, gdzie można szybciej dopytać o materiały lub realizację.',
      },
      {
        target: '[data-tour="site-switcher"]',
        title: 'Język i region',
        text: 'Przełącznik zmienia wersję katalogu. Po zmianie aplikacja załaduje odpowiednie kategorie i ustawienia.',
        placement: 'top' as const,
      },
    ];
  }

  return [
    commonFirstStep,
    {
      target: '[data-tour="planner-title"]',
      title: 'Kalkulator sufitu',
      text: 'Ten przewodnik przeprowadzi Cię przez cały proces: projekt, sufit, narożniki, wymiary, kolory i wynik.',
    },
    {
      target: '[data-tour="project-name"]',
      title: 'Krok 1: nazwa projektu',
      text: 'Możesz wpisać nazwę domu, mieszkania albo klienta. Jeśli zostawisz pole puste, aplikacja utworzy przykładowy projekt.',
    },
    {
      target: '[data-tour="create-project"]',
      title: 'Krok 2: utwórz projekt',
      text: 'Kliknij Dalej, a przewodnik sam utworzy minimalny projekt i przeniesie Cię do następnego kroku.',
      actionTarget: '[data-tour="create-project"]',
    },
    {
      target: '[data-tour="new-ceiling"]',
      title: 'Krok 3: dodaj pomieszczenie',
      text: 'Kliknij Dalej, a przewodnik sam doda pierwszy sufit/pokój do projektu.',
      placement: 'top' as const,
      actionTarget: '[data-tour="new-ceiling"]',
    },
    {
      target: '[data-tour="ceiling-name"]',
      title: 'Krok 4: nazwij pokój',
      text: 'Tutaj później wpiszesz nazwę pomieszczenia, na przykład Salon, Kuchnia albo Pokój 1. Teraz zostawiamy nazwę domyślną.',
    },
    {
      target: '[data-tour="ceiling-corners"]',
      title: 'Krok 5: liczba narożników',
      text: 'Tu ustawiasz liczbę narożników sufitu. Minimalny przykład zostaje z 4 narożnikami, aby od razu było co policzyć.',
    },
    {
      target: '[data-tour="side-length"]',
      title: 'Krok 6: długości boków',
      text: 'Wpisz długość każdego boku w metrach albo użyj plus/minus. Od tego liczy się obwód, powierzchnia i cena.',
    },
    {
      target: '[data-tour="main-color"]',
      title: 'Krok 7: kolor',
      text: 'Wybierz kolor sufitu. Kolor wpływa na wizualizację i późniejsze podsumowanie według kolorów.',
    },
    {
      target: '[data-tour="add-color-variant"]',
      title: 'Krok 8: warianty kolorów',
      text: 'Kliknij Dalej, a przewodnik doda drugi wariant koloru, żeby pokazać porównanie kolorów.',
      actionTarget: '[data-tour="add-color-variant"]',
    },
    {
      target: '[data-tour="ceiling-preview"]',
      title: 'Krok 9: podgląd kształtu',
      text: 'Tutaj widzisz, co powstało: kształt sufitu, narożniki i wybrany kolor. Zmiany w formularzu od razu aktualizują podgląd.',
    },
    {
      target: '[data-tour="ceiling-result"]',
      title: 'Krok 10: wynik dla pokoju',
      text: 'Aplikacja pokazuje powierzchnię, obwód i cenę dla aktualnego sufitu.',
    },
    {
      target: '[data-tour="save-ceiling"]',
      title: 'Krok 11: zapisz sufit',
      text: 'Kliknij Dalej, a przewodnik zapisze przykładowy sufit w projekcie.',
      placement: 'top' as const,
      actionTarget: '[data-tour="save-ceiling"]',
    },
    {
      target: '[data-tour="project-summary-link"]',
      title: 'Krok 12: wróć do projektu',
      text: 'Kliknij Dalej, a przewodnik wróci do podsumowania projektu.',
      actionTarget: '[data-tour="project-summary-link"]',
    },
    {
      target: '[data-tour="project-totals"]',
      title: 'Podsumowanie projektu',
      text: 'Po zapisaniu widzisz łączną powierzchnię, obwód i cenę wszystkich dodanych sufitów w projekcie.',
    },
    {
      target: '[data-tour="color-totals"]',
      title: 'Podsumowanie kolorów',
      text: 'Tutaj sprawdzisz, ile metrów i jaka cena przypada na każdy wybrany kolor.',
    },
    {
      target: '[data-tour="created-ceilings"]',
      title: 'Lista pokoi',
      text: 'Tu są wszystkie dodane sufity/pokoje. Możesz wrócić do każdego, edytować go albo usunąć.',
    },
    {
      target: '[data-tour="catalog-link"]',
      title: 'Katalog materiałów',
      text: 'Katalog przenosi do materiałów, zdjęć, pobierania programu i kontaktów. To kolejna część aplikacji po kalkulatorze.',
    },
    {
      target: '[data-tour="planner-lang"]',
      title: 'Język i region',
      text: 'Tutaj zmieniasz wersję językową aplikacji.',
      placement: 'top' as const,
    },
  ];
});
</script>

<template>
  <button
    type="button"
    class="site-help-button"
    data-tour="help-button"
    aria-label="Open help guide"
    @click="helpTour?.open()"
  >
    ?
  </button>
  <router-view />
  <CookieBanner v-if="!isNative" />
  <HelpTour ref="helpTour" :steps="helpSteps" storage-key="pl-price-site-help-tour-seen-v4" />
</template>

<style scoped>
.site-help-button {
  position: fixed;
  top: max(14px, calc(env(safe-area-inset-top, 0px) + 12px));
  left: max(14px, calc(env(safe-area-inset-left, 0px) + 12px));
  z-index: 1200;
  width: 42px;
  height: 42px;
  border: 1px solid rgba(0, 0, 0, 0.28);
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.16);
  color: #2d2d2d;
  cursor: pointer;
  font-size: 26px;
  font-weight: 800;
  line-height: 1;
}
.site-help-button:active {
  transform: scale(0.96);
}
</style>

<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { CategoriesApi } from '@/api/modules/categories';
import type { CategoryEntity } from '@/types/models/entities/category.entity';
import { inject, onMounted, ref, watch } from 'vue';
import loader from '@/components/loader.vue';
import { RouteName } from '@/types/constants/route-name';
import { KeyboardReturnFilled, TelegramFilled, VideoLibraryTwotone } from '@vicons/material';
import { useRouter } from 'vue-router';
import { useCategoriesStore } from '@/stores/categories';
  
const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const categoriesStore = useCategoriesStore();
const isLoading = ref(false);
const isOpen = ref(false);
const categories = ref<CategoryEntity[]>([]);
const currentCategories = ref<CategoryEntity[]>([]);
const router = useRouter();

const bindCategories = async () => {
  categories.value = categoriesStore.categories;
  setCurrentCategories();
}

const fetchCategories = async () => {
  isLoading.value = true;
  const { data } = (await withErrorHandling(categoriesApi.getCategories()));
  categories.value = data;
  categoriesStore.setCategories(data);
  setCurrentCategories();
}

const setCurrentCategories = () => {
  isLoading.value = true;
  if (props.slug === undefined) {
      currentCategories.value = categories.value;
      isLoading.value = false;
      return;
  }
  currentCategories.value = currentCategories.value.find(c => c.slug === props.slug)?.children ?? [];
  if (currentCategories.value.length === 0) {
    router.push({ name: RouteName.SITE.CATEGORIES.ROOT });
  }
  isLoading.value = false;
}

const props = defineProps({
  slug: String,
})

const innerExpanded = ref<String[]>([]);

const openInner = (item: string) => {
  innerExpanded.value = [item];
}

onMounted(() => {
  if (categoriesStore.categories.length > 0) {
    bindCategories();
    return;
  }
  fetchCategories();
});

watch(
  () => props.slug,
  setCurrentCategories,
  { immediate: true }
);
</script>

<template>
  <div class="page" position="absolute">
    <header class="header" bordered>
      <div class="_container" style="display: flex; justify-content: center;">
        <a href="https://polandgroups.pl/" target="_blank" class="logo _img">
          <img src="../../../assets/logo.png" alt="" />
        </a>
      </div>
    </header>
    <loader v-if="isLoading" />
    <div class="flex flex-center main">
      <div class="_container">
        <div class="_sub-container">
          <div class="content">
            <header class="main__header">
              <h2>Sufity Poland Group doskonałość stylu</h2>
            </header>
            <section class="main__dropdown dropdown" v-if="currentCategories">
              <n-scrollbar style="max-height: 100%">
                <ul class="dropdown__list">
                  <li v-if="props.slug !== undefined" class="dropdown__item">
                    <router-link class="dropdown__button" :to="{ name: RouteName.SITE.CATEGORIES.ROOT }">
                      <n-flex :align="'center'" justify="center" style="position: relative;">
                        <KeyboardReturnFilled width="32px" style="position: absolute; left: 8px;" />
                        <span>Back</span>
                      </n-flex>
                    </router-link>
                  </li>
                  <li v-for="category in currentCategories" :key="category.id">
                    <router-link
                      :to="{
                        name: category.children.length > 0 ? RouteName.SITE.CATEGORIES.SLUG : RouteName.SITE.CATEGORIES.DETAIL,
                        params: { slug: category.slug }
                      }"
                      class="dropdown__button"
                    >{{
                      category.name
                    }}</router-link>
                  </li>

                  <li class="dropdown__item">
                    <n-collapse>
                      <n-collapse-item>
                        <template #arrow>
                          <n-icon></n-icon>
                        </template>
                        <template #header>
                          <a class="dropdown__button" @click="isOpen = !isOpen">
                            Program do budowy sufitów
                          </a>
                        </template>
                        <ul class="tabs">
                          <li class="tab" :class="{ selected: innerExpanded[0] === 'inner-1' }" @click="openInner('inner-1')">Wersja do komputera</li>
                          <li class="tab" :class="{ selected: innerExpanded[0] === 'inner-2' }" @click="openInner('inner-2')">Wersja Do Androida</li>
                          <li class="tab" :class="{ selected: innerExpanded[0] === 'inner-3' }" @click="openInner('inner-3')">Wersja do Apple</li>
                        </ul>
                        <div class="subtabs">
                          <n-collapse v-model:expanded-names="innerExpanded">
                            <n-collapse-item name="inner-1">
                              <template #arrow>
                                <n-icon></n-icon>
                              </template>
                              <template #header>
                              </template>
                              <div class="subtab">
                                <a href="src/assets/NMRDealer.zip">Pobierz</a>
                              </div>
                            </n-collapse-item>
                            <n-collapse-item name="inner-2">
                              <template #arrow>
                                <n-icon></n-icon>
                              </template>
                              <template #header>
                              </template>
                              <div class="subtab">Aplikacja jest w fazie tworzenia i niebawem będzie dostępna</div>
                            </n-collapse-item>
                            <n-collapse-item name="inner-3">
                              <template #arrow>
                                <n-icon></n-icon>
                              </template>
                              <template #header>
                              </template>
                              <div class="subtab">Aplikacja jest w fazie tworzenia i niebawem będzie dostępna</div>
                            </n-collapse-item>
                          </n-collapse>
                        </div>
                      </n-collapse-item>
                    </n-collapse>
                    
                  </li>
                  <li class="dropdown__item">
                    <a class="dropdown__button" href="https://t.me/+aSOZnoJqLyo0ODA8" target="_blank">
                      <n-flex :align="'center'" justify="center" style="position: relative;">
                        <TelegramFilled width="32px" style="position: absolute; left: 8px;" />
                        <span>Telegram</span>
                      </n-flex>
                    </a>
                  </li>
                  <li class="dropdown__item">
                    <a class="dropdown__button" href="https://www.youtube.com/@sufitynapinane8596" target="_blank">
                      <n-flex :align="'center'" justify="center" style="position: relative;">
                        <VideoLibraryTwotone width="32px" style="position: absolute; left: 8px;" />
                        <span>YouTube</span>
                      </n-flex>
                    </a>
                  </li>
                </ul>
              </n-scrollbar>
              
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
  
</template>

<style>

.n-config-provider {
  display: flex;
  flex-direction: column;
}
.page {
  flex: 1 1 100%;
}

.n-collapse-item-arrow {
  display: none !important;
}
.subtabs .n-collapse-item__header {
  display: none !important;
}
.subtabs .n-collapse-item {
  margin: 0 !important;
  border: none !important;
}
.subtabs .n-collapse {
  border: none !important;
}
.subtab {
  margin-bottom: 16px;
}

.tabs {
  display: flex;
}

.tab {
  cursor: pointer;
  font-size: 18px;
  font-weight: 300;
  flex: 1 1 auto;
  min-height: 36px;
  margin: 16px 0 0;
  text-align: center;
  position: relative;
}
.tab::before {
  content: '';
  position: absolute;
  background: rgb(239,4,4);
  height: 1px;
  width: 0;
  bottom: 0;
  transition: width .3s ease-in-out !important;
}
.tab:first-child::before {
  left: 0;
  width: 0;
}

.tab:hover::before, .tab.selected::before {
  width: 100%;
}

.tab:last-child::before {
  right: 0;
}


.tab:not(:first-child):not(:last-child)::before {
  left: 50%;
  transform: translateX(-50%);
}

.subtab a {
  font-size: 1rem;
  width: 33.3%;
  display: block;
  margin: 0 auto;
  padding: 12px;
  border-radius: 8px;
  background: rgba(221, 221, 221, .5);
  border: 1px solid #000;
  color: inherit;
  transition: all 0.3s ease 0s;
}

.subtab a:hover {
  border: 1px solid #ff0031;
  color: #ff0031 !important;
}

</style>
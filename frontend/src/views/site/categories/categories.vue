<script setup lang="ts">
import { withErrorHandling } from '@/api/api-error-handler';
import type { CategoriesApi } from '@/api/modules/categories';
import type { CategoryEntity } from '@/types/models/entities/category.entity';
import { inject, onMounted, ref, watch } from 'vue';
import loader from '@/components/loader.vue';
import { RouteName } from '@/types/constants/route-name';
import { KeyboardReturnFilled, TelegramFilled, VideoLibraryTwotone } from '@vicons/material';
import { useRouter } from 'vue-router';
  
const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const isLoading = ref(false);
const categories = ref<CategoryEntity[]>([]);
const currentCategories = ref<CategoryEntity[]>([]);
const router = useRouter();

const fetchCategories = async () => {
  isLoading.value = true;
  const { data } = (await withErrorHandling(categoriesApi.getCategories()));
  categories.value = data;
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

onMounted(() => {
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
          <img src="/logo.png" alt="" />
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
              <ul class="dropdown__list">
                <li v-if="props.slug !== undefined" class="dropdown__item">
                  <router-link class="dropdown__button" :to="{ name: RouteName.SITE.CATEGORIES.ROOT }">
                    <n-flex :align="'center'" justify="center" style="position: relative;">
                      <KeyboardReturnFilled width="32px" style="position: absolute; left: 8px;" />
                      <span>Back</span>
                    </n-flex>
                  </router-link>
                </li>
                <template v-for="category in currentCategories" :key="category.id">
                  <router-link
                    :to="{
                      name: category.children.length > 0 ? RouteName.SITE.CATEGORIES.SLUG : RouteName.SITE.CATEGORIES.DETAIL,
                      params: { slug: category.slug }
                    }"
                    class="dropdown__button"
                  >{{
                    category.name
                  }}</router-link>
                </template>

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
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
  
</template>

<style>
.page {
  background: url('../../../assets/background.jpg') center / cover no-repeat;
}
</style>
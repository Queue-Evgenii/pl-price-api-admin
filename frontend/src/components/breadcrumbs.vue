<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { NBreadcrumb, NBreadcrumbItem } from 'naive-ui';

const route = useRoute();

const breadcrumbs = computed(() => {
  const matched = route.matched.filter(r => r.meta?.breadcrumb);

  return matched.map((record) => {
    const label = typeof record.meta.breadcrumb === 'function'
      ? record.meta.breadcrumb(route)
      : record.meta.breadcrumb;

    return {
      label,
      path: record.path,
    };
  });
});
</script>

<template>
  <n-breadcrumb separator="/">
    <n-breadcrumb-item v-for="(item, index) in breadcrumbs" :key="index">
      <router-link
        v-if="index < breadcrumbs.length - 1"
        :to="item.path"
        style="text-decoration: none"
      >
        {{ item.label }}
      </router-link>
      <span v-else>{{ item.label }}</span>
    </n-breadcrumb-item>
  </n-breadcrumb>
</template>

<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';
import { ArrowBackIosFilled } from '@vicons/material';

defineProps<{ to: RouteLocationRaw }>();
</script>

<template>
  <router-link :to="to" class="back-link" aria-label="Back">
    <ArrowBackIosFilled aria-hidden="true" />
    <span>Back</span>
  </router-link>
</template>

<style scoped>
.back-link {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-height: 44px;
  padding: 0 44px;
  border: 1px solid #000;
  border-radius: 8px;
  background: #ddd;
  color: #3d3d3d;
  font-size: 32px;
  font-weight: 700;
  line-height: 1.25;
  text-decoration: none;
}
.back-link svg {
  position: absolute;
  left: 8px;
  width: 32px;
  height: 32px;
}
.back-link:focus-visible {
  outline: 2px solid #3d3d3d;
  outline-offset: 3px;
}
@media (max-width: 600px) {
  .back-link {
    font-size: 24px;
  }
}
</style>

<script setup lang="ts">
import { NCard } from 'naive-ui'
</script>

<template>
  <div
    style="
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: var(--n-color-blank-card);
    "
  >
    <n-card
      style="text-align: center; width: 320px; padding: 2rem;"
      :bordered="false"
      :hoverable="false"
    >
      <h1
        style="
          color: var(--n-warning-color);
          margin-bottom: 1rem;
          font-weight: 700;
          font-size: 2rem;
        "
      >
        Page Not Found
      </h1>
      <p style="color: var(--n-text-color-secondary)">
        The page you are looking for does not exist.
      </p>
    </n-card>
  </div>
</template>

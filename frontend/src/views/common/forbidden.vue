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
      style="text-align: center; width: 300px; padding: 2rem;"
      :bordered="false"
      :hoverable="false"
    >
      <h1
        style="
          color: var(--n-error-color);
          margin-bottom: 1rem;
          font-weight: 700;
          font-size: 2rem;
        "
      >
        Forbidden
      </h1>
      <p style="color: var(--n-text-color-secondary)">
        You don't have permission to access this page.
      </p>
    </n-card>
  </div>
</template>

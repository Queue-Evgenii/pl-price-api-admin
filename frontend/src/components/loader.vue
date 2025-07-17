<template>
  <div class="loader">
    <span class="dot"></span>
    <span class="dot"></span>
    <span class="dot"></span>
  </div>
</template>

<script setup>
</script>

<style scoped>
.loader {
  position: fixed;
  top: 0;
  width: 100%;
  height: 100%;
  z-index: 5000;
  background: rgba(224, 224, 224, 0.6);

  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
}

.dot {
  width: 18px;
  height: 18px;
  background-color: rgb(255, 0, 49);
  border-radius: 50%;
  animation: bounce 1.5s infinite ease-in-out;
}

.dot:nth-child(1) {
  animation-delay: 0s;
}

.dot:nth-child(2) {
  animation-delay: 0.2s;
}

.dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes bounce {

  0%,
  80%,
  100% {
    transform: translateY(0);
  }

  40% {
    transform: translateY(-10px);
  }
}
</style>

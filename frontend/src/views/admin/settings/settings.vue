<script setup>
import { ref, onMounted } from 'vue'

// Reactive state
const sites = ref([])
const loading = ref(false)

// Lifecycle
onMounted(async () => {
    // Load data
})

// Methods
const fetchSites = async () => {
    loading.value = true
    try {
        // Fetch sites data
    } finally {
        loading.value = false
    }
}
</script>

<template>
    <div class="sites-container">
        setts
    </div>
</template>

<style scoped>
/* Your styles here */
</style>
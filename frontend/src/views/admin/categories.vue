<script setup lang="ts">
import { ref, onMounted, reactive, h, inject } from 'vue'
import type { DataTableColumns } from 'naive-ui'
import { NInput, NButton, useMessage } from 'naive-ui'
import type { CategoryEntity } from '@/types/models/entities/category.entity'
import type { CategoriesApi } from '@/api/modules/categories'

const message = useMessage()

const categories = ref<CategoryEntity[]>([])
const editingCategory = ref<CategoryEntity | null>(null)
const showModal = ref(false)

const openEditModal = (row: CategoryEntity) => {
  editingCategory.value = { ...row }
  showModal.value = true
}

const saveChanges = () => {
  if (!editingCategory.value) return

  const index = categories.value.findIndex(cat => cat.id === editingCategory.value?.id)
  if (index !== -1) {
    categories.value[index] = { ...editingCategory.value }
    message.success(`Изменения сохранены: ${editingCategory.value.name}`)
  }
  showModal.value = false
  editingCategory.value = null
}

const addCategory = () => {
  const newId = categories.value.length + 1
  editingCategory.value = {
    id: newId,
    name: '',
    slug: '',
    parent: undefined,
    children: [],
  }
  showModal.value = true
}

const columns: DataTableColumns<CategoryEntity> = [
  {
    title: 'ID',
    key: 'id',
    resizable: true
  },
  {
    title: 'Название',
    key: 'name',
  },
  {
    title: 'Slug',
    key: 'slug',
  },
  {
    title: 'Действия',
    key: 'actions',
    width: 100,
    render(row) {
      return h(
        NButton,
        {
          size: 'small',
          type: 'primary',
          onClick: () => openEditModal(row),
        },
        { default: () => 'Edit' }
      )
    },
  },
]

const pagination = reactive({
  page: 1,
  pageSize: 5,
  showSizePicker: true,
  pageSizes: [3, 5, 10],
  onChange: (page: number) => {
    pagination.page = page
  },
  onUpdatePageSize: (pageSize: number) => {
    pagination.pageSize = pageSize
    pagination.page = 1
  },
})

const fetchCategories = async () => {
  const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
  categories.value = await categoriesApi.getCategories();
}

onMounted(() => {
  fetchCategories();
})

</script>

<template>
  <n-card title="Категории (таблица)">
    <n-data-table
      :columns="columns"
      :data="categories"
      :pagination="pagination"
      :row-key="(row) => row.id"
      default-expand-all
      bordered
    />
  </n-card>

  <div style="position: fixed; bottom: 20px; right: 20px;">
    <n-button type="primary" size="large" circle @click="addCategory">+</n-button>
  </div>

  <n-modal v-model:show="showModal" title="Редактировать категорию" preset="dialog">
  <div v-if="editingCategory" style="display: flex; flex-direction: column; gap: 1rem;">
    <n-input
      v-model:value="editingCategory.name"
      placeholder="Название"
    />
    <n-input
      v-model:value="editingCategory.slug"
      placeholder="Slug"
    />
    <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
      <n-button @click="showModal = false">Отмена</n-button>
      <n-button type="primary" @click="saveChanges">Сохранить</n-button>
    </div>
  </div>
</n-modal>

</template>


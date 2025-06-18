<script setup lang="ts">
import { ref, onMounted, reactive, h } from 'vue'
import type { DataTableColumns } from 'naive-ui'
import { NInput, NButton, useMessage } from 'naive-ui'

interface CategoryEntity {
  id: number
  name: string
  slug: string
  parent: CategoryEntity | null
  children: CategoryEntity[]
  isEditing?: boolean
}

const message = useMessage()

const mockCategories: CategoryEntity[] = [
  {
    id: 1,
    name: 'Электроника',
    slug: 'elektronika',
    parent: null,
    children: [
      {
        id: 2,
        name: 'Смартфоны',
        slug: 'smartfony',
        parent: null,
        children: [],
      },
    ],
  },
  {
    id: 3,
    name: 'Одежда',
    slug: 'odezhda',
    parent: null,
    children: [],
  },
]

const tableData = ref<CategoryEntity[]>([])

const toggleEdit = (row: CategoryEntity) => {
  row.isEditing = !row.isEditing
  if (!row.isEditing) {
    message.success(`Сохранено: ${row.name}`)
  }
}

const addCategory = () => {
  const newId = tableData.value.length + 1
  tableData.value.push({
    id: newId,
    name: '',
    slug: '',
    parent: null,
    children: [],
    isEditing: true,
  })
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
    render(row) {
      return row.isEditing
        ? h(NInput, {
            value: row.name,
            onUpdateValue: (val) => (row.name = val),
            placeholder: 'Введите название',
          })
        : row.name
    },
  },
  {
    title: 'Slug',
    key: 'slug',
    render(row) {
      return row.isEditing
        ? h(NInput, {
            value: row.slug,
            onUpdateValue: (val) => (row.slug = val),
            placeholder: 'Введите slug',
          })
        : row.slug
    },
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
          type: row.isEditing ? 'success' : 'primary',
          onClick: () => toggleEdit(row),
        },
        { default: () => (row.isEditing ? 'Save' : 'Edit') }
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

onMounted(() => {
  tableData.value = mockCategories
})

</script>

<template>
  <n-card title="Категории (таблица)">
    <n-data-table
      :columns="columns"
      :data="tableData"
      :pagination="pagination"
      :row-key="(row) => row.id"
      default-expand-all
      bordered
    />
  </n-card>

  <div
    style="
      position: fixed;
      bottom: 20px;
      right: 20px;
    "
  >
    <n-button type="primary" size="large" circle @click="addCategory">
      +
    </n-button>
  </div>
</template>

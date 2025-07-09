<script setup lang="ts">
import { ref, onMounted, reactive, h, inject } from 'vue'
import type { DataTableColumns } from 'naive-ui'
import { NInput, NButton, useMessage } from 'naive-ui'
import type { CategoryEntity } from '@/types/models/entities/category.entity'
import type { CategoriesApi } from '@/api/modules/categories'
import { useCategoriesStore } from '@/stores/categories'
import type { CategoriesMetaDto } from '@/types/models/dto/categories-dto'
import { RouterLink } from 'vue-router'
import type { _DeepPartial } from 'pinia'

const message = useMessage()
const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const categoriesStore = useCategoriesStore();
const categoriesMeta = ref<CategoriesMetaDto | null>(null);
const editingCategory = ref<CategoryEntity | null>(null);
const showModal = ref(false);

const openEditModal = (row: CategoryEntity) => {
  editingCategory.value = { ...row };
  showModal.value = true;
}

const saveChanges = async () => {
  if (!editingCategory.value) {
    showModal.value = false;
    return;
  }
  if (editingCategory.value.id === -1) {
    const payload = { name: editingCategory.value.name, slug: editingCategory.value.slug, parentId: editingCategory.value.parent ? editingCategory.value.parent.id : undefined };
    const createdCategory = await categoriesApi.createCategory(payload);
    categoriesStore.addCategory(createdCategory);
  } else {
    const updatedCategory = await categoriesApi.patchCategory(editingCategory.value.id, editingCategory.value);
    categoriesStore.replaceCategory(updatedCategory);
  }
  showModal.value = false;
}

const addCategory = (row: CategoryEntity | undefined) => {
  const newCategory: CategoryEntity = {
    id: -1,
    name: '',
    slug: '',
    children: [],
  };

  if (row !== undefined) {
    newCategory.parent = { id: row.id };
  }

  openEditModal(newCategory);
}

const deleteCategory = (row: CategoryEntity) => {
  categoriesApi.deleteCategory(row.id);
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
    width: 220,
    render(row) {
      return h('div', { style: 'display: flex; gap: 8px;' }, [
        h(
          NButton,
          {
            size: 'small',
            type: 'primary',
            onClick: () => addCategory(row),
          },
          { default: () => 'Add' }
        ),
        h(
          RouterLink,
          { to: `/categories/${row.id}` },
          {
            default: () =>
              h(
                NButton,
                { size: 'small', type: 'info' },
                { default: () => 'Details' }
              ),
          }
        ),
        h(
          NButton,
          {
            size: 'small',
            type: 'info',
            onClick: () => openEditModal(row),
          },
          { default: () => 'Edit' }
        ),
        h(
          NButton,
          {
            size: 'small',
            type: 'error',
            onClick: () => deleteCategory(row),
          },
          { default: () => 'Delete' }
        )
      ]);
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
  const { data, meta } = (await categoriesApi.getCategories());
  categoriesMeta.value = meta;
  categoriesStore.setCategories(data);
}

onMounted(() => {
  fetchCategories();
});

</script>

<template>
  <n-card title="Categories (table)">
    <n-data-table
      :columns="columns"
      :data="categoriesStore.categories"
      :pagination="pagination"
      :row-key="(row: CategoryEntity) => row.id"
      default-expand-all
      bordered
    />
  </n-card>

  <div style="position: fixed; bottom: 20px; right: 20px;">
    <n-button type="primary" size="large" circle @click="() => addCategory(undefined)">+</n-button>
  </div>

  <n-modal v-if="editingCategory" v-model:show="showModal" :title="`${editingCategory.id !== -1 ? 'Edit' : 'Create'} category`" preset="dialog">
    <div style="display: flex; flex-direction: column; gap: 1rem;">
      <n-input
        v-model:value="editingCategory.name"
        placeholder="Name"
      />
      <n-input
        v-model:value="editingCategory.slug"
        placeholder="Slug"
      />
      <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
        <n-button @click="showModal = false">Cancel</n-button>
        <n-button type="primary" @click="saveChanges">Save</n-button>
      </div>
    </div>
  </n-modal>

</template>


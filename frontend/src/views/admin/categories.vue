<script setup lang="ts">
import { ref, onMounted, reactive, h, inject } from 'vue'
import type { DataTableColumns } from 'naive-ui'
import { DeleteFilled, EditFilled, AddCircleFilled, FolderOpenRound } from '@vicons/material'
import { NPagination, NDataTable, NInput, NButton, useMessage, NIcon } from 'naive-ui'
import type { CategoryEntity } from '@/types/models/entities/category.entity'
import type { CategoriesApi } from '@/api/modules/categories'
import { useCategoriesStore } from '@/stores/categories'
import type { CategoriesMetaDto } from '@/types/models/dto/categories-dto'
import { RouterLink, useRoute } from 'vue-router'
import type { _DeepPartial } from 'pinia'
import { AxiosError } from 'axios'

const message = useMessage();
const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const categoriesStore = useCategoriesStore();
const categoriesMeta = ref<CategoriesMetaDto | null>(null);
const editingCategory = ref<CategoryEntity | null>(null);
const isCategoryAdding = ref(false);
const isDeleteConfirmation = ref(false);
const route = useRoute();

// ===== CRUD =====
const saveChanges = async () => {
  if (!editingCategory.value) {
    isCategoryAdding.value = false;
    editingCategory.value = null;
    return;
  }
  try {
    if (editingCategory.value.id === -1) {
      const payload = { name: editingCategory.value.name, slug: editingCategory.value.slug, parentId: editingCategory.value.parent ? editingCategory.value.parent.id : undefined };
      const createdCategory = await categoriesApi.createCategory(payload);
      categoriesStore.addCategory(createdCategory);
      message.success("Category successfully added!");
    } else {
      const updatedCategory = await categoriesApi.updateCategory(editingCategory.value.id, editingCategory.value);
      categoriesStore.replaceCategory(updatedCategory);
      message.success("Category successfully changed!");
    }
  } catch (e: unknown) {
    if (e instanceof AxiosError) {
      message.error(e.response?.data.message);
    } else {
      message.error("Unknown error occurred");
    }
  }
  closeEditModal();
}

const deleteCategory = async (id: number) => {
  try {
    await categoriesApi.deleteCategory(id);
    categoriesStore.deleteCategoryWithId(id);
    
    message.success("Category successfully deleted!");
  } catch (e: unknown) {
    if (e instanceof AxiosError) {
      message.error(e.response?.data.message);
    } else {
      message.error("Unknown error occurred");
    }
  }
  closeDeleteModal();
}

const fetchCategories = async (page = 1, pageSize = 10) => {
  const { data, meta } = (await categoriesApi.getCategories({ page, limit: pageSize }));
  categoriesMeta.value = meta;
  categoriesStore.setCategories(data);

  pagination.page = meta.page;
  pagination.pageSize = meta.limit;
  pagination.itemCount = meta.total;
}

// ===== UI =====
const openEditModal = (row: CategoryEntity) => {
  editingCategory.value = { ...row };
  isCategoryAdding.value = true;
}
const closeEditModal = () => {
  editingCategory.value = null;
  isCategoryAdding.value = false;
}

const openDeleteModal = (row: CategoryEntity) => {
  editingCategory.value = { ...row };
  isDeleteConfirmation.value = true;
}
const closeDeleteModal = () => {
  editingCategory.value = null;
  isDeleteConfirmation.value = false;
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
      const renderIcon = (iconComponent: any) =>
        h(NIcon, null, { default: () => h(iconComponent) });
      
      return h('div', { style: 'display: flex; gap: 8px;' }, [
        h(
          NButton,
          {
            size: 'small',
            type: 'primary',
            onClick: () => addCategory(row),
          },
          {
            icon: () => renderIcon(AddCircleFilled),
            default: () => 'Add'
          }
        ),
        h(
          RouterLink,
          { to: `${route.path}/${row.id}/photos` },
          {
            default: () =>
              h(
                NButton,
                { size: 'small', type: 'info' },
                {
                  icon: () => renderIcon(FolderOpenRound),
                  default: () => 'Details'
                }
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
          {
            icon: () => renderIcon(EditFilled),
            default: () => 'Edit'
          }
        ),
        h(
          NButton,
          {
            size: 'small',
            type: 'error',
            onClick: () => openDeleteModal(row),
          },
          {
            icon: () => renderIcon(DeleteFilled),
            default: () => 'Delete'
          }
        )
      ]);
    },
  },
]

const pagination = reactive({
  page: 1,
  pageSize: 10,
  showSizePicker: true,
  pageSizes: [5, 10, 15],
  itemCount: 0,
  onChange: (page: number) => {
    console.log(page)
    fetchCategories(page, pagination.pageSize);
  },
  onUpdatePageSize: (pageSize: number) => {
    fetchCategories(1, pageSize);
  },
})


onMounted(() => {
  fetchCategories(pagination.page, pagination.pageSize);
});

</script>

<template>
  <n-card title="Categories (table)">
    <n-data-table
      :columns="columns"
      :data="categoriesStore.categories"
      :row-key="(row: CategoryEntity) => row.id"
      bordered
    />
    <n-pagination
        v-model:page="pagination.page"
        v-model:page-size="pagination.pageSize"
        :page-sizes="pagination.pageSizes"
        :item-count="pagination.itemCount"
        @update:page="pagination.onChange"
        @update-page-size="pagination.onUpdatePageSize"
        show-size-picker
        style="justify-content: right; margin-top: 16px;" />
  </n-card>

  <div style="position: fixed; bottom: 20px; right: 20px;">
    <n-button type="primary" size="large" circle @click="() => addCategory(undefined)">+</n-button>
  </div>

  <n-modal v-if="editingCategory" v-model:show="isCategoryAdding" :title="`${editingCategory.id !== -1 ? 'Edit' : 'Create'} category`" preset="dialog" v-model:on-after-leave="closeEditModal">
    <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 16px;">
      <n-input
        v-model:value="editingCategory.name"
        placeholder="Name"
      />
      <n-input
        v-model:value="editingCategory.slug"
        placeholder="Slug"
      />
      <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
        <n-button @click="closeEditModal">Cancel</n-button>
        <n-button type="primary" @click="saveChanges">Save</n-button>
      </div>
    </div>
  </n-modal>
  
  <n-modal v-if="editingCategory" v-model:show="isDeleteConfirmation" :title="`Sure you want to delete category ${editingCategory.id}`" preset="dialog" v-model:on-after-leave="closeDeleteModal">
    <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 16px;">
      <n-input
        v-model:value="editingCategory.name"
        placeholder="Name"
        disabled
      />
      <n-input
        v-model:value="editingCategory.slug"
        placeholder="Slug"
        disabled
      />
      <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
        <n-button @click="closeDeleteModal">Cancel</n-button>
        <n-button type="error" @click="() => { if (editingCategory) deleteCategory(editingCategory.id) }">Delete</n-button>
      </div>
    </div>
  </n-modal>

</template>


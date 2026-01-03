<script setup lang="ts">
import { withErrorHandling } from "@/api/api-error-handler";
import type { SitesApi } from "@/api/modules/sites";
import { useSitesStore } from "@/stores/sites";
import type { CreateSiteDto } from "@/types/models/dto/sites-dto";
import type { SiteEntity } from "@/types/models/entities/site.entity";
import { DeleteFilled, EditFilled } from "@vicons/material";
import { AxiosError } from "axios";
import { NButton, NIcon, NSwitch, NTag, NTooltip, useMessage, type DataTableColumns } from "naive-ui";
import { h, inject, ref } from "vue";

const message = useMessage();
const sitesApi = inject<SitesApi>('SitesApi')!;
const sitesStore = useSitesStore();
const editingSite = ref<SiteEntity | null>(null);
const isSiteAdding = ref(false);
const isDeleteConfirmation = ref(false);

const openEditModal = (row: SiteEntity) => {
  editingSite.value = { ...row };
  isSiteAdding.value = true;
}
const closeEditModal = () => {
  editingSite.value = null;
  isSiteAdding.value = false;
}

const openDeleteModal = (row: SiteEntity) => {
  editingSite.value = { ...row };
  isDeleteConfirmation.value = true;
}
const closeDeleteModal = () => {
  editingSite.value = null;
  isDeleteConfirmation.value = false;
}

const addCategory = (row: SiteEntity | undefined) => {
  const newSite: SiteEntity = {
    id: -1,
    name: '',
    code: '',
    active: false,
  };

  openEditModal(newSite);
}

const switchStatus = (site: SiteEntity, newStatus: boolean) => {
  editingSite.value = { ...site, active: newStatus };
  saveChanges();
}

const saveChanges = async () => {
  if (!editingSite.value) {
    isSiteAdding.value = false;
    editingSite.value = null;
    return;
  }
  try {
    if (editingSite.value.id === -1) {
      const payload: CreateSiteDto = { name: editingSite.value.name, code: editingSite.value.code, active: editingSite.value.active };
      const createdSite = await withErrorHandling(sitesApi.create(payload));
      sitesStore.setSites([...sitesStore.sites, createdSite]);
      message.success("Site successfully added!");
    } else {
      const updatedSite = await withErrorHandling(sitesApi.update(editingSite.value.id, editingSite.value));
      sitesStore.replaceSite(updatedSite);
      message.success("Site successfully changed!");
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
    await withErrorHandling(sitesApi.delete(id));
    sitesStore.deleteSiteWithId(id);
    
    message.success("Site successfully deleted!");
  } catch (e: unknown) {
    if (e instanceof AxiosError) {
      message.error(e.response?.data.message);
    } else {
      message.error("Unknown error occurred");
    }
  }
  closeDeleteModal();
}

const columns: DataTableColumns<SiteEntity> = [
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
    title: 'Code',
    key: 'code',
  },
  {
    title: 'Действия',
    key: 'actions',
    width: 220,
    render(row) {
      const renderIcon = (iconComponent: any) =>
        h(NIcon, null, { default: () => h(iconComponent) });
      
      return h('div', { style: 'display: flex; gap: 8px; align-items: center' }, [
        h('img', {
            src: `${import.meta.env.VITE_API_URL}/static/flags/${row.code}.svg`,
            width: 24,
            height: 18,
        }),
        h(
          NSwitch,
          {
            size: 'small',
            type: 'info',
            value: row.active,
            'onUpdate:value': (val) => {
              row.active = val
              switchStatus(row, val)
            }
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

</script>

<template>
    <n-card title="Sites (table)">
        <n-data-table
            :columns="columns"
            :data="sitesStore.sites"
            :row-key="(row: SiteEntity) => row.id"
            bordered
        />
    </n-card>

    <div style="position: fixed; bottom: 20px; right: 20px">
        <n-button
            type="primary"
            size="large"
            circle
            @click="() => addCategory(undefined)"
            >+</n-button
        >
    </div>

    <n-modal
        v-if="editingSite"
        v-model:show="isSiteAdding"
        :title="`${editingSite.id !== -1 ? 'Edit' : 'Create'} category`"
        preset="dialog"
        v-model:on-after-leave="closeEditModal"
    >
        <div
            style="
                display: flex;
                flex-direction: column;
                gap: 1rem;
                margin-top: 16px;
            "
        >
            <n-input
                v-model:value="editingSite.name"
                placeholder="Name"
            />
            <n-input
                v-model:value="editingSite.code"
                placeholder="Code"
            />
            <div style="display: flex; justify-content: flex-end; gap: 0.5rem">
                <n-button @click="closeEditModal">Cancel</n-button>
                <n-button type="primary" @click="saveChanges">Save</n-button>
            </div>
        </div>
    </n-modal>

    <n-modal
        v-if="editingSite"
        v-model:show="isDeleteConfirmation"
        :title="`Sure you want to delete category ${editingSite.id}`"
        preset="dialog"
        v-model:on-after-leave="closeDeleteModal"
    >
        <div
            style="
                display: flex;
                flex-direction: column;
                gap: 1rem;
                margin-top: 16px;
            "
        >
            <n-input
                v-model:value="editingSite.name"
                placeholder="Name"
                disabled
            />
            <n-input
                v-model:value="editingSite.code"
                placeholder="Slug"
                disabled
            />
            <div style="display: flex; justify-content: flex-end; gap: 0.5rem">
                <n-button @click="closeDeleteModal">Cancel</n-button>
                <n-button
                    type="error"
                    @click="
                        () => {
                            if (editingSite)
                                deleteCategory(editingSite.id);
                        }
                    "
                    >Delete</n-button
                >
            </div>
        </div>
    </n-modal>
</template>

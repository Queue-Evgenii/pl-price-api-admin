<script setup lang="ts">
import { ref, reactive, onMounted, inject, watch } from "vue";
import { useMessage, type UploadFileInfo } from "naive-ui";
import type { SettingsAdminApi } from "@/api/modules/settings";
import type { SettingsEntity } from "@/types/models/entities/settings.entity";
import type { PhotoEntity } from "@/types/models/entities/photo.entity";
import { withErrorHandling } from "@/api/api-error-handler";
import {
    NForm,
    NFormItem,
    NInput,
    NButton,
    NUpload,
    NSpin,
    NCard,
    NSwitch,
    NFlex,
} from "naive-ui";
import { DeleteFilled } from "@vicons/material";
import { useSettingsStore } from "@/stores/settings";

const settingsAdminApi = inject<SettingsAdminApi>("SettingsAdminApi")!;
const settingsStore = useSettingsStore();
const message = useMessage();

const loading = ref(true);

const form = reactive<Partial<SettingsEntity>>({});

onMounted(async () => {
    try {
        const data = await withErrorHandling(settingsAdminApi.getSettings());
        settingsStore.setSettings(data);
        Object.assign(form, data);
    } finally {
        loading.value = false;
    }
});

const beforeUpload = (uploadFile: { file: UploadFileInfo }) => {
    const file = uploadFile?.file?.file;
    if (!file) return false;

    const isLt5MB = file.size / 1024 / 1024 < 5; // допустим до 5MB
    if (!isLt5MB) {
        message.error("Размер файла должен быть меньше 5MB");
    }
    return isLt5MB;
};

const handleUpload = async ({ file }: { file: UploadFileInfo }) => {
    if (!file.file) return;
    try {
        const uploaded: PhotoEntity = await settingsAdminApi.addPhoto(
            file.file as File,
        );
        form.banner = uploaded;
        message.success("Баннер загружен!");
    } catch (err) {
        console.error(err);
        message.error("Ошибка при загрузке баннера");
    }
};

const removeBanner = async () => {
    if (!form.banner?.id) return;
    try {
        await settingsAdminApi.deletePhoto(form.banner.id);
        form.banner = undefined;
        message.success("Баннер удален");
    } catch (err) {
        console.error(err);
        message.error("Ошибка при удалении баннера");
    }
};

const submit = async () => {
    try {
        const saved = await withErrorHandling(
            settingsAdminApi.updateSettings(form as SettingsEntity),
        );
        Object.assign(form, saved);
        settingsStore.setSettings(saved);
        message.success("Настройки успешно сохранены!");
    } catch (err) {
        console.error(err);
        message.error("Ошибка при сохранении");
    }
};

watch(
  () => settingsStore.settings,
  (newSettings) => {
    if (newSettings) {
      Object.assign(form, newSettings);
    }
  },
  { deep: true, immediate: true }
);
</script>

<template>
    <n-spin :show="loading">
        <n-card>
            <n-form v-if="settingsStore.settings" :model="form" label-width="250">
                <n-form-item label="Заголовок">
                    <n-input v-model:value="form.title" />
                </n-form-item>

                <n-form-item label="Скачать приложение - Заголовок">
                    <n-input v-model:value="form.downloadSectionButtonText" />
                </n-form-item>

                <!-- PC Tab -->
                <n-form-item label="Таб - Скачать PC - Заголовок">
                    <n-input v-model:value="form.downloadTabPcTitle" />
                </n-form-item>
                <n-form-item label="Таб - Скачать PC - Кнопка">
                    <n-input v-model:value="form.downloadTabPcButtonText" />
                </n-form-item>
                <n-form-item label="Таб - Скачать PC - Текст">
                    <n-input v-model:value="form.downloadTabPcEmptyText" />
                </n-form-item>

                <!-- Android Tab -->
                <n-form-item label="Таб - Скачать Android - Заголовок">
                    <n-input v-model:value="form.downloadTabAndroidTitle" />
                </n-form-item>
                <n-form-item label="Таб - Скачать Android - Кнопка">
                    <n-input
                        v-model:value="form.downloadTabAndroidButtonText"
                    />
                </n-form-item>
                <n-form-item label="Таб - Скачать Android - Текст">
                    <n-input v-model:value="form.downloadTabAndroidEmptyText" />
                </n-form-item>

                <!-- iOS Tab -->
                <n-form-item label="Таб - Скачать Apple - Заголовок">
                    <n-input v-model:value="form.downloadTabIosTitle" />
                </n-form-item>
                <n-form-item label="Таб - Скачать Apple - Кнопка">
                    <n-input v-model:value="form.downloadTabIosButtonText" />
                </n-form-item>
                <n-form-item label="Таб - Скачать Apple - Текст">
                    <n-input v-model:value="form.downloadTabIosEmptyText" />
                </n-form-item>

                <n-form-item label="Баннер">
                    <n-upload
                        accept="image/*"
                        :show-file-list="false"
                        @change="handleUpload"
                        @before-upload="beforeUpload"
                    >
                        <n-button type="primary">Выбрать баннер</n-button>
                    </n-upload>

                    <div v-if="form.banner" style="margin-top: 12px">
                        <n-card
                            hoverable
                            style="display: block; text-align: center"
                        >
                            <n-image
                                :src="form.banner.url"
                                width="200"
                                height="200"
                                object-fit="contain"
                            />
                            <div style="margin-top: 4px">
                                <n-button
                                    size="small"
                                    type="error"
                                    @click="removeBanner"
                                >
                                    <template #icon>
                                        <DeleteFilled />
                                    </template>
                                    Удалить
                                </n-button>
                            </div>
                        </n-card>
                    </div>
                </n-form-item>

                <n-button type="primary" @click="submit">Сохранить</n-button>
            </n-form>
        </n-card>
    </n-spin>
</template>

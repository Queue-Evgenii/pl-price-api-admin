import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { _DeepPartial } from "pinia";
import type { PhotosDto, UpdatePhotosDto } from "@/types/models/dto/photos-dto";
import type { PhotoEntity } from "@/types/models/entities/photo.entity";
import type { SettingsEntity } from "@/types/models/entities/settings.entity";

export class SettingsAdminApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/admin');
  }
  
  getSettings = () => {
    return this.getRequest<SettingsEntity>('/settings');
  };
  
  updateSettings = (payload: _DeepPartial<SettingsEntity>) => {
    return this.patchRequest<SettingsEntity, _DeepPartial<SettingsEntity>>(`/settings`, payload);
  };
  
  addPhoto = (file: File) => {
    const formData = new FormData();
    formData.append('file', file);

    return this.postRequest<PhotoEntity, FormData>(`/settings/banner`, formData);
  };
  
  updatePhoto = (id: number, payload: UpdatePhotosDto) => {
    return this.patchRequest<PhotosDto, UpdatePhotosDto>(`/settings/banner/${id}`, payload);
  };
  
  deletePhoto = (id: number) => {
    return this.deleteRequest<PhotosDto>(`/settings/banner/${id}`);
  };
}

export class SettingsApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '');
  }
  
  getSettings = () => {
    return this.getRequest<SettingsEntity>('/settings');
  };
}
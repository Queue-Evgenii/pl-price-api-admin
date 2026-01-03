import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { SiteEntity } from "@/types/models/entities/site.entity";
import type { CreateSiteDto } from "@/types/models/dto/sites-dto";
import type { _DeepPartial } from "pinia";

export class SitesApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/admin');
  }
  
  getAll = (params?: { page: number, limit: number }) => {
    return this.getRequest<SiteEntity[]>('/sites', params);
  };
  
  create = (payload: CreateSiteDto) => {
    return this.postRequest<SiteEntity, CreateSiteDto>('/sites', payload);
  };
    
  update = (id: number, payload: _DeepPartial<SiteEntity>) => {
    return this.patchRequest<SiteEntity, _DeepPartial<SiteEntity>>(`/sites/${id}`, payload);
  };
  
  delete = (id: number) => {
    return this.deleteRequest<void>(`/sites/${id}`);
  };
}
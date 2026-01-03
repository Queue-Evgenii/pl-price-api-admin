import type { SiteEntity } from '@/types/models/entities/site.entity';
import { Site } from '@/types/models/utils/browser/site';
import { defineStore } from 'pinia';
import { h, type RendererElement, type RendererNode, type VNode } from 'vue';

interface SitesState {
  _sites: SiteEntity[];
  _site: SiteEntity | undefined;
}

export interface SiteOpt { label: () => VNode<RendererNode, RendererElement, { [key: string]: any; }>, value: string };

export const useSitesStore = defineStore('sites', {
  state: (): SitesState => ({
    _sites: [],
    _site: undefined
  }),
  getters: {
    sites(): SiteEntity[] {
      return this._sites;
    },
    site(): SiteEntity | undefined {
      return this._site;
    },
    opts(): SiteOpt[] {
      return this.toOpt(this._sites);
    },
    curOpt(): SiteOpt {
      return this.toOpt(this._site);
    }
  },
  actions: {
    setSite(site: SiteEntity | string | undefined): void {
      if (site === undefined) {
        this._site = undefined;
        return;
      }
      if (typeof site === 'string') {
        this._site = this._sites.find(el => el.code === site);
      } else {
        this._site = site;
      }

      if (this._site === undefined) {
        Site.remove();
        return;
      }
      Site.set(this._site.code);
    },
    setSites(sites: SiteEntity[]): void {
      this._sites = [...sites];
    },
    clearState(): void {
      this._sites = [];
      this._site = undefined;
    },
    toOpt(sites: SiteEntity | SiteEntity[]): SiteOpt | SiteOpt[] {
      const process = (el: SiteEntity) => ({
        value: el.code,
        label: () =>
          h('span', { style: 'display: inline-flex; align-items:center; gap: 8px' }, [
            h('img', {
              src: `${import.meta.env.VITE_API_URL}/static/flags/${el.code}.svg`,
              width: 16,
              height: 12,
            }),
            el.name
          ]),
      })

      if (sites === undefined) {
        return [];
      }

      if (Array.isArray(sites)) {
        return this.sites.map(el => process(el));
      }
      return process(sites)
    },
    
    replaceSite(updatedCategory: SiteEntity) {
      for (let i = 0; i < this._sites.length; i++) {
        const site = this._sites[i];
    
        if (site.id === updatedCategory.id) {
          this._sites[i] = updatedCategory;
          return true;
        }
  
      }
    },
    deleteSiteWithId(id: number) {
      for (let i = 0; i < this._sites.length; i++) {
        const site = this._sites[i];
    
        if (site.id === id) {
          this._sites.splice(i, 1);
          return true;
        }
  
      }
    },
  },
});
import { defineStore } from 'pinia';

export type ColorPreset = {
  label: string;
  value: string;
}

export type Variant = {
  id: string;
  color: string;
  colorName: string;
  isFavorite: boolean;
  createdAt: string;
}

export type Ceiling = {
  id: string;
  name: string;
  corners: number;
  sides: number[];
  variants: Variant[];
  activeVariantId: string;
  createdAt: string;
  updatedAt?: string;
}

export type Project = {
  id: string;
  name: string;
  ceilings: Ceiling[];
  createdAt: string;
  updatedAt?: string;
}

interface CeilingProjectsState {
  _projects: Project[];
}

const STORAGE_KEY = 'ceiling-estimator-projects-v2';

const readProjects = (): Project[] => {
  if (typeof localStorage === 'undefined') {
    return [];
  }

  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];

    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
};

export const useCeilingProjectsStore = defineStore('ceilingProjects', {
  state: (): CeilingProjectsState => ({
    _projects: readProjects(),
  }),
  getters: {
    projects(): Project[] {
      return this._projects;
    },
  },
  actions: {
    setProjects(projects: Project[]) {
      this._projects = [...projects];
      this.persist();
    },
    setProjectsDraft(projects: Project[]) {
      this._projects = [...projects];
    },
    persist() {
      if (typeof localStorage === 'undefined') {
        return;
      }

      localStorage.setItem(STORAGE_KEY, JSON.stringify(this._projects));
    },
  },
});

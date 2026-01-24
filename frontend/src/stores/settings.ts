import type { SettingsEntity } from '@/types/models/entities/settings.entity';
import { defineStore } from 'pinia';

interface SettingsState {
  _settings: SettingsEntity | undefined;
}

export const useSettingsStore = defineStore('settings', {
  state: (): SettingsState => ({
    _settings: undefined,
  }),
  getters: {
    settings(): SettingsEntity | undefined {
      return this._settings;
    },
  },
  actions: {
    setSettings(settings: SettingsEntity) {
      this._settings = settings;
    },
  },
});
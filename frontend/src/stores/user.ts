import type { UserEntity, UserRoles } from '@/types/models/entities/user.entity';
import { defineStore } from 'pinia';

interface UserState {
  _user: UserEntity | undefined;
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    _user: undefined,
  }),
  getters: {
    user(): UserEntity | undefined {
      return this._user;
    },
    userRole(): UserRoles | undefined {
      return this._user?.role;
    }
  },
  actions: {
    setUser(user: UserEntity) {
      this._user = { ...user };
    },
    clearState(): void {
      this._user = undefined;
    },
  },
});
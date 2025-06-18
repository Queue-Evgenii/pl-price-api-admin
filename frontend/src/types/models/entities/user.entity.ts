export enum UserRoles {
  DEFAULT = 'default',
  ADMIN = 'admin',
};

export interface UserEntity {
  id: number;

  email: string;

  password: string;

  name: string;

  role: UserRoles;
}
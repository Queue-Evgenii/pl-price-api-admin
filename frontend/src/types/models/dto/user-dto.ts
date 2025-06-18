import type { UserEntity } from "../entities/user.entity";

export interface UserDto {
  token: string;

  user: UserEntity;
}
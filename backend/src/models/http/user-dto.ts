import { UserEntity } from 'src/orm/user.entity';

export interface UserRequestDto {
  email: string;
  password: string;
}

export interface UserResponseDto {
  token: string;
  user: UserEntity;
}

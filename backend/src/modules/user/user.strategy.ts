import { UserDto } from 'src/models/user-dto';
import { UserEntity } from 'src/orm/user.entity';

export interface UserStrategy {
  create(user: UserDto): Promise<UserEntity>;

  findByEmail(email: string): Promise<UserEntity | null>;
}

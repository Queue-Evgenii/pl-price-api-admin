import { UserRequestDto } from 'src/models/http/user-dto';
import { UserEntity } from 'src/orm/user.entity';

export interface UserStrategy {
  create(user: UserRequestDto): Promise<UserEntity>;

  findByEmail(email: string): Promise<UserEntity | null>;
}

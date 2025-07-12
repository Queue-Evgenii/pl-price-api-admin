import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserRequestDto } from 'src/models/http/user-dto';
import { UserEntity } from 'src/orm/user.entity';
import { Repository } from 'typeorm';
import { UserStrategy } from './user.strategy';
import { PasswordStrategy } from '../password/password.strategy';
import { UserRoles } from 'src/models/roles';

@Injectable()
export class UserService implements UserStrategy {
  constructor(
    @InjectRepository(UserEntity) private usersRepo: Repository<UserEntity>,
    @Inject('PasswordService') private passwordService: PasswordStrategy,
  ) {}

  async create(userDto: UserRequestDto): Promise<UserEntity> {
    const password = await this.passwordService.hash(userDto.password);
    const user = this.usersRepo.create({
      ...userDto,
      password,
      role: UserRoles.ADMIN,
    });
    return this.usersRepo.save(user);
  }

  async findByEmail(email: string): Promise<UserEntity | null> {
    return this.usersRepo.findOne({ where: { email } });
  }
}

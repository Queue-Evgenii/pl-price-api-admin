import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserDto } from 'src/models/user-dto';
import { UserEntity } from 'src/orm/user.entity';
import { Repository } from 'typeorm';
import { UserStrategy } from './user.strategy';
import { PasswordService } from '../password/password.service';

@Injectable()
export class UserService implements UserStrategy {
  constructor(
    @InjectRepository(UserEntity) private usersRepo: Repository<UserEntity>,
    @Inject('PasswordService') private passwordService: PasswordService,
  ) {}

  async create(userDto: UserDto): Promise<UserEntity> {
    const password = await this.passwordService.hash(userDto.password)
    const user = this.usersRepo.create({
      ...userDto,
      password,
    });
    return this.usersRepo.save(user);
  }

  async findByEmail(email: string): Promise<UserEntity | null> {
    return this.usersRepo.findOne({ where: { email } });
  }
}

import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/orm/user.entity';
import { PasswordModule } from '../password/password.module';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity]), PasswordModule],
  providers: [
    {
      provide: 'UserService',
      useClass: UserService,
    },
  ],
  exports: ['UserService'],
})
export class UserModule {}

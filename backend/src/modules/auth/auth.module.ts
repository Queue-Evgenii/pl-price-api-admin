import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { TokenModule } from 'src/modules/token/token.module';
import { UserModule } from '../user/user.module';
import { PasswordModule } from '../password/password.module';

@Module({
  imports: [TokenModule, UserModule, PasswordModule],
  controllers: [AuthController],
  providers: [
    {
      provide: 'AuthService',
      useClass: AuthService,
    },
  ],
  exports: ['AuthService'],
})
export class AuthModule {}

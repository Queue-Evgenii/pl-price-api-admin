import { Module } from '@nestjs/common';
import { PasswordService } from './password.service';

@Module({
  providers: [
    {
      provide: 'PasswordService',
      useClass: PasswordService,
    },
  ],
  exports: ['PasswordService'],
})
export class PasswordModule {}

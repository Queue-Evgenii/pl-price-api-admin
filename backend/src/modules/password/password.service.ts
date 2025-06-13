import { Injectable } from '@nestjs/common';
import { PasswordStrategy } from './password.strategy';
import * as bcrypt from 'bcrypt';

@Injectable()
export class PasswordService implements PasswordStrategy {
  async hash(password: string): Promise<string> {
    return await bcrypt.hash(password, 10);
  }
  async compare(
    givenPassword: string,
    originPassword: string,
  ): Promise<boolean> {
    return await bcrypt.compare(givenPassword, originPassword);
  }
}

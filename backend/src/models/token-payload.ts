import { ApiProperty } from '@nestjs/swagger';
import { UserRoles } from './roles';

export class TokenPayload {
  @ApiProperty()
  email: string;

  @ApiProperty()
  role: UserRoles;
}

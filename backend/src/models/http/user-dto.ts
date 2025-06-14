import { UserEntity } from 'src/orm/user.entity';
import { ApiProperty } from '@nestjs/swagger';

export class UserRequestDto {
  @ApiProperty()
  email: string;

  @ApiProperty()
  password: string;
}

export class UserResponseDto {
  @ApiProperty()
  token: string;

  @ApiProperty({ type: UserEntity })
  user: UserEntity;
}

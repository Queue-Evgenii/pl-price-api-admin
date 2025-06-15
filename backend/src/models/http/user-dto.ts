import { UserEntity } from 'src/orm/user.entity';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class UserRequestDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  password: string;
}

export class UserResponseDto {
  @ApiProperty()
  token: string;

  @ApiProperty({ type: UserEntity })
  user: UserEntity;
}

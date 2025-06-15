import { ApiProperty } from '@nestjs/swagger';

export class HttpErrorDto {
  @ApiProperty()
  statusCode: number;

  @ApiProperty()
  message: string;

  @ApiProperty()
  error: string;
}

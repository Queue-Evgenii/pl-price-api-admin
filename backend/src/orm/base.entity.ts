import { ApiProperty } from '@nestjs/swagger';
import { CreateDateColumn, Timestamp, UpdateDateColumn } from 'typeorm';

export abstract class BaseEntity {
  @CreateDateColumn({ name: 'created_at' })
  @ApiProperty()
  createdAt: Timestamp;

  @UpdateDateColumn({ name: 'updated_at' })
  @ApiProperty()
  updatedAt: Timestamp;
}

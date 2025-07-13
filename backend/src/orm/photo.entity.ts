import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { CategoryEntity } from './category.entity';
import { BaseEntity } from './base.entity';

@Entity()
export class PhotoEntity extends BaseEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @ApiProperty()
  url: string;

  @ManyToOne(() => CategoryEntity, (category) => category.photos, { onDelete: 'CASCADE' })
  @ApiProperty({ type: () => CategoryEntity })
  category: CategoryEntity;

  @Column({ nullable: false, unique: true })
  @ApiProperty()
  orderId: number;

  @Column({ type: 'boolean', default: false })
  @ApiProperty()
  isActive: boolean;
}

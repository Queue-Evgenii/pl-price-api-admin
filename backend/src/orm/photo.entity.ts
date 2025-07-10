import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { CategoryEntity } from './category.entity';

@Entity()
export class PhotoEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @ApiProperty()
  path: string;

  @ManyToOne(() => CategoryEntity, (category) => category.photos, { onDelete: 'CASCADE' })
  @ApiProperty({ type: () => CategoryEntity })
  category: CategoryEntity;
}

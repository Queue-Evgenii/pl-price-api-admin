import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, ManyToOne, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { CategoryEntity } from './category.entity';
import { BaseEntity } from './base.entity';
import { SettingsEntity } from './settings.entity';

@Entity()
export class PhotoEntity extends BaseEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @ApiProperty()
  url: string;

  @Column({ nullable: true, type: 'varchar', length: 255 })
  @ApiProperty()
  name?: string;

  @ManyToOne(() => CategoryEntity, (category) => category.photos, { onDelete: 'CASCADE' })
  @ApiProperty({ type: () => CategoryEntity })
  category: CategoryEntity;

  @OneToOne(() => SettingsEntity, (setting) => setting.banner, { onDelete: 'CASCADE' })
  @ApiProperty({ type: () => SettingsEntity })
  settings: SettingsEntity;

  @Column({ nullable: false })
  @ApiProperty()
  orderId: number;

  @Column({ type: 'boolean', default: false })
  @ApiProperty()
  isActive: boolean;
}

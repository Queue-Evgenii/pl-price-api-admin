import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, OneToMany, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { CategoryEntity } from './category.entity';
import { SettingsEntity } from './settings.entity';

@Entity()
export class SiteEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ unique: true })
  @ApiProperty()
  code: string;

  @Column({ nullable: true })
  @ApiProperty()
  name: string;

  @Column({ type: 'boolean', default: false })
  @ApiProperty()
  active: boolean

  @OneToMany(() => CategoryEntity, (category) => category.site)
  @ApiProperty({ type: () => [CategoryEntity] })
  categories: CategoryEntity[];

  @OneToOne(() => SettingsEntity, (setting) => setting.site)
  @ApiProperty({ type: () => [SettingsEntity] })
  settings: SettingsEntity;
}

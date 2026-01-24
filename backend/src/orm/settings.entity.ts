import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, JoinColumn, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { SiteEntity } from './site.entity';
import { PhotoEntity } from './photo.entity';
import { BaseEntity } from './base.entity';

@Entity()
export class SettingsEntity extends BaseEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ nullable: true })
  @ApiProperty()
  title: string;

  @OneToOne(() => PhotoEntity, (photo) => photo.settings, { onDelete: 'SET NULL' })
  @ApiProperty({ type: () => [PhotoEntity] })
  @JoinColumn({ name: 'banner_id' })
  banner: PhotoEntity;

  @Column({ nullable: true })
  @ApiProperty()
  downloadSectionButtonText: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabPcTitle: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabAndroidTitle: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabIosTitle: string;

  /** PC */
  @Column({ nullable: true })
  @ApiProperty()
  downloadTabPcButtonText: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabPcEmptyText: string;

  /** Android */
  @Column({ nullable: true })
  @ApiProperty()
  downloadTabAndroidButtonText: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabAndroidEmptyText: string;

  /** iOS */
  @Column({ nullable: true })
  @ApiProperty()
  downloadTabIosButtonText: string;

  @Column({ nullable: true })
  @ApiProperty()
  downloadTabIosEmptyText: string;

  @OneToOne(() => SiteEntity, (site) => site.settings, { onDelete: 'SET NULL' })
  @ApiProperty({ type: () => SiteEntity })
  @JoinColumn({ name: 'site_code', referencedColumnName: 'code' })
  site: SiteEntity;
}

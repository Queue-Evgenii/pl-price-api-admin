import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsInt } from 'class-validator';

export class UpdateSettingRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  bannerId?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadSectionButtonText?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabPcTitle?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabAndroidTitle?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabIosTitle?: string;

  /** PC */
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabPcButtonText?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabPcEmptyText?: string;

  /** Android */
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabAndroidButtonText?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabAndroidEmptyText?: string;

  /** iOS */
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabIosButtonText?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  downloadTabIosEmptyText?: string;
}

import { Body, Controller, Delete, Get, Inject, Param, Post, ParseIntPipe, UseGuards, Patch } from '@nestjs/common';
import { MultisiteAdminStrategy } from '../services/multisite.strategy';
import { CreateSiteRequestDto, UpdateSiteRequestDto } from 'src/models/http/site-dto';
import { SiteEntity } from 'src/orm/site.entity';
import { AuthGuard } from 'src/guards/auth.guard';

@Controller('sites')
export class MultisiteController {
  constructor(
    @Inject('MultisiteAdminService')
    private readonly multisiteAdminService: MultisiteAdminStrategy,
  ) { }

  @Post()
  @UseGuards(AuthGuard)
  async create(@Body() dto: CreateSiteRequestDto): Promise<SiteEntity> {
    return this.multisiteAdminService.create(dto);
  }

  @Patch(':id')
  @UseGuards(AuthGuard)
  async update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateSiteRequestDto): Promise<SiteEntity> {
    return this.multisiteAdminService.update(id, dto);
  }

  @Delete(':id')
  @UseGuards(AuthGuard)
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.multisiteAdminService.remove(id);
  }

  @Get(':id')
  @UseGuards(AuthGuard)
  async getOne(@Param('id', ParseIntPipe) id: number): Promise<SiteEntity> {
    return this.multisiteAdminService.findOne(id);
  }

  @Get()
  async getAll(): Promise<SiteEntity[]> {
    return this.multisiteAdminService.findAll();
  }
}

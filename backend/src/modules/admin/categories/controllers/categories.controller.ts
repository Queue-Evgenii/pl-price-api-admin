import { Body, Controller, Delete, Get, Inject, Param, ParseIntPipe, Patch, Post, Query, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { CreateCategoryRequestDto, FindAllCategoriesOptionsDto, SwapCategoriesRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoriesAdminStrategy } from '../services/categories.strategy';
import { ApiCreateResponses, ApiFindAllResponses, ApiFindOneResponses, ApiRemoveResponses, ApiUpdateResponses } from 'src/decorators/categories.decorator';
import { ApiTokenResponse } from 'src/decorators/token.decorator';
import { CategoriesStrategy } from 'src/modules/categories/services/categories.strategy';

@Controller('categories')
export class CategoriesController {
  constructor(
    @Inject('CategoriesAdminService') private categoriesAdminService: CategoriesAdminStrategy,
    @Inject('CategoriesService') private categoriesService: CategoriesStrategy,
  ) {}

  @Post()
  @UseGuards(AuthGuard)
  @ApiCreateResponses()
  @ApiTokenResponse()
  create(@Body() dto: CreateCategoryRequestDto) {
    return this.categoriesAdminService.create(dto);
  }

  @Get()
  @ApiFindAllResponses()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Query() query: FindAllCategoriesOptionsDto) {
    return this.categoriesService.findAll(query);
  }

  @Get(':id')
  @ApiFindOneResponses()
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.findOne(id);
  }

  @Patch('id/:id')
  @UseGuards(AuthGuard)
  @ApiUpdateResponses()
  @ApiTokenResponse()
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateCategoryRequestDto) {
    return this.categoriesAdminService.update(id, dto);
  }

  @Patch('swap')
  @UseGuards(AuthGuard)
  @ApiTokenResponse()
  @UsePipes(new ValidationPipe({ transform: true }))
  swap(@Body() dto: SwapCategoriesRequestDto) {
    return this.categoriesAdminService.swap(dto.sourceId, dto.targetId);
  }

  @Delete(':id')
  @UseGuards(AuthGuard)
  @ApiRemoveResponses()
  @ApiTokenResponse()
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesAdminService.remove(id);
  }
}

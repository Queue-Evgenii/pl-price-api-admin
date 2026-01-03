import { Body, Controller, Delete, Get, Headers, Inject, Param, ParseIntPipe, Patch, Post, Query, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { CreateCategoryRequestDto, FindAllCategoriesOptionsDto, SwapCategoriesRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoriesAdminStrategy } from '../services/categories.strategy';
import { ApiCreateResponses, ApiFindAllResponses, ApiFindOneResponses, ApiRemoveResponses, ApiUpdateResponses } from 'src/decorators/categories.decorator';
import { ApiTokenResponse } from 'src/decorators/token.decorator';

@Controller('categories')
@UseGuards(AuthGuard)
export class CategoriesController {
  constructor(@Inject('CategoriesAdminService') private categoriesAdminService: CategoriesAdminStrategy) {}

  @Post()
  @ApiCreateResponses()
  @ApiTokenResponse()
  create(@Body() dto: CreateCategoryRequestDto, @Headers('content-language') lang: string) {
    return this.categoriesAdminService.create(dto, lang);
  }

  @Get()
  @ApiFindAllResponses()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Query() query: FindAllCategoriesOptionsDto, @Headers('content-language') lang: string) {
    return this.categoriesAdminService.findAll(query, lang);
  }

  @Get(':id')
  @ApiFindOneResponses()
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesAdminService.findOne(id);
  }

  @Patch('id/:id')
  @ApiUpdateResponses()
  @ApiTokenResponse()
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateCategoryRequestDto) {
    return this.categoriesAdminService.update(id, dto);
  }

  @Patch('swap')
  @ApiTokenResponse()
  @UsePipes(new ValidationPipe({ transform: true }))
  swap(@Body() dto: SwapCategoriesRequestDto) {
    return this.categoriesAdminService.swap(dto.sourceId, dto.targetId);
  }

  @Delete(':id')
  @ApiRemoveResponses()
  @ApiTokenResponse()
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesAdminService.remove(id);
  }
}

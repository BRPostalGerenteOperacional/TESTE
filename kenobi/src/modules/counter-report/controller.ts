import { Controller, Post, Body } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'

import {
  CreateCounterReportDto,
  CreateReportResponseDTO,
} from './dto/create-counter-report.dto'

import { CounterReportService } from './service'

@ApiTags('counter-report')
@Controller('counter-report')
export class CounterReportController {
  constructor(private readonly counterReportService: CounterReportService) {}

  @ApiOperation({ summary: 'Criar Relatório' })
  @ApiResponse({
    status: 200,
    description: 'Retorno do Relatório dos Pedidos',
    type: CreateReportResponseDTO,
  })
  @Post()
  create(@Body() createCounterReportDto: CreateCounterReportDto) {
    return this.counterReportService.create(createCounterReportDto)
  }
}

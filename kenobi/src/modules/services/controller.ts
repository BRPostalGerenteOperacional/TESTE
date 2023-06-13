import { Controller, Get } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'
import { ServicesService } from './service'

@ApiTags('services')
@Controller('services')
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @ApiOperation({ summary: 'Buscar todos os servicos' })
  @ApiResponse({
    status: 200,
    description: 'Servicos encontradas',
    isArray: true,
  })
  @Get()
  findAll() {
    return this.servicesService.findAll()
  }
}

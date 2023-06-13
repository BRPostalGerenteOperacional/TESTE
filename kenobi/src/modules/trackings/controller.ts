import { Controller, Get, Param, Query } from '@nestjs/common'
import { ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger'
import { ObjetoTrackDTO } from './dto/CorreiosTrack.dto'

import { TrackingsService } from './service'

@ApiTags('trackings')
@Controller('tracking')
export class TrackingsController {
  constructor(private readonly trackingsService: TrackingsService) {}

  @ApiOperation({ summary: 'Tracking Correios Object' })
  @ApiResponse({ status: 404, description: 'Objeto não encontrado na base dos Correios' })
  @ApiResponse({
    status: 200,
    description: 'Objeto encontrado e retornado',
    type: ObjetoTrackDTO,
  })
  @ApiResponse({
    status: 400,
    description: 'Requisição incrreta, verifique se enviou os dados corretos',
  })
  @ApiQuery({
    description:
      'Tipo de resultado da pesquisa. T para todos os eventos, P para apenas o primeiro evento e U para apenas o último evento.',
    enum: ['T', 'P', 'U'],
    name: 'evento',
  })
  @Get('correios/:codObjeto')
  findOne(
    @Param('codObjeto') objectId: string,
    @Query('evento') evento: 'T' | 'P' | 'U'
  ) {
    return this.trackingsService.trackingCorreiosObject(objectId, evento)
  }
  @Get('jt/:codObjeto')
  findJTOne(
    @Param('codObjeto') objectId: string
  ) {
    return this.trackingsService.trackingJTObject(objectId)
  }
}

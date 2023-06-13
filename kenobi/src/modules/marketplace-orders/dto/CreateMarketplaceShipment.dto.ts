import { ApiProperty } from '@nestjs/swagger'

export class CreateMarketplaceShipmentDTO {
  @ApiProperty({
    required: true,
    description: 'Nome do Marketplace referente à etiqueta',
  })
  marketplace_name: string

  @ApiProperty({
    required: true,
    description: 'ID da etiqueta na transportadora para o rastreio',
  })
  tracking_id: string

  @ApiProperty({
    required: false,
    description: 'ZipCode (CEP) de quem receberá o envio',
  })
  to_zip_code?: string
}

export class CreateMarketplaceOrderDTO {
  @ApiProperty({
    required: true,
    description: 'Registro de envios para o pedido',
    isArray: true,
    type: CreateMarketplaceShipmentDTO,
  })
  shipments: CreateMarketplaceShipmentDTO[]

  @ApiProperty({
    required: true,
    description: 'ID do Usuário (balcão) referente à aquele envio',
  })
  user_id: number
}

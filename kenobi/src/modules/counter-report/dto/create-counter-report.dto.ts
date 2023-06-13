import { ApiProperty } from '@nestjs/swagger'

export class CreateCounterReportDto {
  @ApiProperty({
    required: true,
    description: 'Mês referente ao relatório gerado',
    type: String,
    enum: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    maxLength: 2,
  })
  month: '01' | '02' | '03' | '04' | '05' | '06' | '07' | '08' | '09' | '10' | '11' | '12'

  @ApiProperty({
    required: true,
    description: 'Ano referente ao relatório gerado',
    type: Number,
    minLength: 4,
    maxLength: 4,
    example: '2022',
  })
  year: number | string

  @ApiProperty({
    required: true,
    description: 'Id referenciador ao usuário balcão',
    type: Number,
    example: 1,
  })
  counter_id: number

  @ApiProperty({
    required: true,
    description: 'Tipo das ordens para serem buscadas',
    type: String,
    enum: ['marketplace', 'standard'],
    example: 'standard',
  })
  order_type: 'marketplace' | 'standard'
}

class MarketPlaceShipment {
  @ApiProperty()
  id: string

  @ApiProperty()
  marketplace_order_id: string

  @ApiProperty()
  marketplace_name: string

  @ApiProperty()
  tracking_id: string

  @ApiProperty()
  to_zip_code: string

  @ApiProperty()
  created_at: Date

  @ApiProperty()
  updated_at: Date
}

class StandardShipment {
  @ApiProperty()
  id: string

  @ApiProperty()
  amount: number

  @ApiProperty()
  weight: string

  @ApiProperty()
  external_id: string

  @ApiProperty()
  to_zip_code: string

  @ApiProperty()
  created_at: Date

  @ApiProperty()
  updated_at: Date
}

export class OrdersDataDTO {
  @ApiProperty()
  id: string

  @ApiProperty()
  objects_quantity: string

  @ApiProperty()
  user_id: string

  @ApiProperty()
  created_at: Date

  @ApiProperty()
  updated_at: Date

  @ApiProperty({ type: [MarketPlaceShipment] })
  marketplace_shipments?: MarketPlaceShipment[]

  @ApiProperty({ type: [StandardShipment] })
  shipments?: StandardShipment[]
}

export class CreateReportResponseDTO {
  @ApiProperty({
    type: String,
    description: 'String arquivo CSV para download',
  })
  csv: string

  @ApiProperty({
    type: [OrdersDataDTO],
    description: 'Ordens feitas pelo balcão no mês buscado',
  })
  orders: OrdersDataDTO[]
}

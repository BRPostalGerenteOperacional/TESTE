import { Controller, Get, Post, Body, Param } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'

import { MarketplaceOrdersService } from './service'
import { CreateMarketplaceOrderDTO } from './dto/CreateMarketplaceShipment.dto'

@ApiTags('marketplace-order')
@Controller('marketplace-order')
export class MarketplaceShipmentController {
  constructor(private readonly marketplaceShipmentService: MarketplaceOrdersService) {}

  @ApiOperation({ summary: 'Create MarketPlace Shipment' })
  @Post()
  create(@Body() data: CreateMarketplaceOrderDTO) {
    return this.marketplaceShipmentService.create(data)
  }

  @ApiOperation({ summary: 'Find All MarketPlace shipments by user' })
  @Get('user/:userId')
  findAllByUser(@Param('userId') userId: number) {
    return this.marketplaceShipmentService.findAllByUser(Number(userId))
  }

  @ApiOperation({ summary: 'Find MarketPlace order' })
  @Get(':orderId')
  findOrder(@Param('orderId') orderId: number) {
    return this.marketplaceShipmentService.findOne(Number(orderId))
  }
}

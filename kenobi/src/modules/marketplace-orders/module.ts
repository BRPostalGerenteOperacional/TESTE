import { Module } from '@nestjs/common'

import { PrismaModule } from '../prisma/module'

import { MarketplaceOrdersService } from './service'
import { MarketplaceShipmentController } from './controller'

@Module({
  imports: [PrismaModule],
  controllers: [MarketplaceShipmentController],
  providers: [MarketplaceOrdersService],
})
export class MarketplaceOrdersModule {}

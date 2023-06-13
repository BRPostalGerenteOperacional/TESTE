import { Module } from '@nestjs/common'
import { ScheduleModule } from '@nestjs/schedule'

import { AppController } from './controller'
import { PrismaModule } from '../prisma/module'
import { RatesModule } from '../rates/module'
import { ShipmentsModule } from '../shipments/module'
import { TrackingsModule } from '../trackings/module'
import { MarketplaceOrdersModule } from '../marketplace-orders/module'
import { CounterReportModule } from '../counter-report/module'
import { UsersModule } from '../users/module'
import { AddressModule } from '../address/module'
import { AdminsModule } from '../admins/module'
import { CategoriesModule } from '../categories/module'
import { ServicesModule } from '../services/module'

@Module({
  controllers: [AppController],
  imports: [
    ScheduleModule.forRoot(),
    PrismaModule,
    RatesModule,
    ShipmentsModule,
    TrackingsModule,
    MarketplaceOrdersModule,
    CounterReportModule,
    UsersModule,
    AddressModule,
    AdminsModule,
    CategoriesModule,
    ServicesModule,
  ],
})
export class AppModule {}

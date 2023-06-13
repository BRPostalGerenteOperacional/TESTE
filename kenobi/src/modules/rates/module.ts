import { Module } from '@nestjs/common'

import { PrismaModule } from '../prisma/module'

import { RatesController } from './controller'
import { RatesService } from './service'

@Module({
  imports: [PrismaModule],
  controllers: [RatesController],
  providers: [RatesService],
})
export class RatesModule {}

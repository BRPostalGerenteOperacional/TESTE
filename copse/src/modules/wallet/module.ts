import { Module } from '@nestjs/common'
import { PrismaModule } from '../prisma/module'

import { WalletController } from './controller'
import { WalletService } from './service'

@Module({
  imports: [PrismaModule],
  controllers: [WalletController],
  providers: [WalletService],
  exports: [WalletService],
})
export class WalletModule {}

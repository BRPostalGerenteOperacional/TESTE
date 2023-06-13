import { Module } from '@nestjs/common'

import { PrismaModule } from '../prisma/module'
import { WalletModule } from '../wallet/module'
import { DebitModule } from '../debit/module'

import { CreditController } from './controller'
import { CreditService } from './service'

@Module({
  imports: [PrismaModule, WalletModule, DebitModule],
  controllers: [CreditController],
  providers: [CreditService],
})
export class CreditModule {}

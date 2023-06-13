import { Module } from '@nestjs/common'

import { AppController } from './controller'

import { PrismaModule } from '../prisma/module'
import { WalletModule } from '../wallet/module'
import { CreditModule } from '../credit/module'
import { DebitModule } from '../debit/module'

@Module({
  controllers: [AppController],
  imports: [PrismaModule, WalletModule, CreditModule, DebitModule],
})
export class AppModule { }

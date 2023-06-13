import { Module } from '@nestjs/common'

import { PrismaModule } from '../prisma/module'
import { WalletModule } from '../wallet/module'
import { DebitController } from './controller'
import { DebitService } from './service'

@Module({
  imports: [PrismaModule, WalletModule],
  controllers: [DebitController],
  providers: [DebitService],
  exports: [DebitService],
})
export class DebitModule {}

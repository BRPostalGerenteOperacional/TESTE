import { Module } from '@nestjs/common'
import { ShipmentsService } from './service'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  providers: [ShipmentsService],
})
export class ShipmentsModule {}

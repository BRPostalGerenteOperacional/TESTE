import { Module } from '@nestjs/common'
import { ServicesService } from './service'
import { ServicesController } from './controller'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  controllers: [ServicesController],
  providers: [ServicesService],
})
export class ServicesModule {}

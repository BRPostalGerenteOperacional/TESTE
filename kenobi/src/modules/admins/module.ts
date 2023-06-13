import { Module } from '@nestjs/common'
import { AdminsService } from './service'
import { AdminsController } from './controller'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  controllers: [AdminsController],
  providers: [AdminsService],
})
export class AdminsModule {}

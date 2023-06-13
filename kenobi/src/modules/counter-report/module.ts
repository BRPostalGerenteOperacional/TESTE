import { Module } from '@nestjs/common'
import { CounterReportService } from './service'
import { CounterReportController } from './controller'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  controllers: [CounterReportController],
  providers: [CounterReportService],
})
export class CounterReportModule {}

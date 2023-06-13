import { Module } from '@nestjs/common'

import { TrackingsService } from './service'
import { TrackingsController } from './controller'

@Module({
  controllers: [TrackingsController],
  providers: [TrackingsService],
})
export class TrackingsModule {}

import { Module } from '@nestjs/common'
import { AddressService } from './service'
import { AddressController } from './controller'

@Module({
  controllers: [AddressController],
  providers: [AddressService],
})
export class AddressModule {}

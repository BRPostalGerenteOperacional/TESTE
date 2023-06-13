import { Module } from '@nestjs/common'
import { UsersService } from './service'
import { UsersController } from './controller'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}

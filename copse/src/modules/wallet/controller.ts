import * as NestCommon from '@nestjs/common'
import { Wallet } from '@prisma/client'
import { ApiOperation } from '@nestjs/swagger'

import { CreateWalletDTO } from './dto/CreateWallet.dto'

import { WalletService } from './service'

@NestCommon.Controller('/wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @NestCommon.Post()
  @ApiOperation({ summary: 'Create a wallet' })
  create(@NestCommon.Body() walletData: CreateWalletDTO): Promise<Wallet> {
    return this.walletService.create(walletData)
  }

  @NestCommon.Get('/:ownerId')
  @ApiOperation({ summary: 'Get wallet by owner id' })
  findByOwner(@NestCommon.Param('ownerId') ownerId: number) {
    return this.walletService.findByOwner(Number(ownerId))
  }
}

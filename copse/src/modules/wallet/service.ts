import { Injectable, NotFoundException } from '@nestjs/common'
import { Prisma, Wallet } from '@prisma/client'

import { PrismaService } from '../prisma/service'
import { AddCreditDTO } from './dto/AddCredit.dto'
import { AddDebitDTO } from './dto/AddDebit.dto'

@Injectable()
export class WalletService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: Prisma.WalletCreateInput): Promise<Wallet> {
    return await this.prisma.wallet.create({
      data,
    })
  }

  async findByOwner(ownerId: number): Promise<any> {
    const wallet = await this.prisma.wallet.findUnique({
      where: { ownerId },
      select: {
        id: true,
        balance: true,
        ownerId: true,
        updatedAt: true,
        debits: true,
        credits: true,
      },
    })

    if (!wallet) throw new NotFoundException('Wallet not found!')

    return wallet
  }

  async findById(id: string): Promise<any> {
    const wallet = await this.prisma.wallet.findUnique({
      where: { id },
      select: {
        id: true,
        balance: true,
        ownerId: true,
        updatedAt: true,
      },
    })

    if (!wallet) throw new NotFoundException('Wallet not found!')

    return wallet
  }

  async addCredit(data: AddCreditDTO, walletData: Wallet): Promise<any> {
    const newBalance = Number(walletData.balance) + Number(data.quantity)

    return await this.prisma.wallet.update({
      where: { id: walletData.id },
      data: {
        balance: newBalance,
      },
    })
  }

  async addDebit(data: AddDebitDTO, walletData: Wallet): Promise<any> {
    const newBalance = Number(walletData.balance) - Number(data.quantity)

    return await this.prisma.wallet.update({
      where: { id: walletData.id },
      data: {
        balance: newBalance,
      },
    })
  }
}

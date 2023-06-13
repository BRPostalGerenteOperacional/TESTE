import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common'
import { Prisma, WalletDebit } from '@prisma/client'

import { PrismaService } from '../prisma/service'
import { WalletService } from '../wallet/service'

@Injectable()
export class DebitService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wallet: WalletService
  ) {}

  async create(data: Prisma.WalletDebitCreateManyInput): Promise<WalletDebit> {
    const wallet = await this.wallet.findById(data.walletId)

    if (!wallet) throw new NotFoundException('Wallet not found!')

    const balance = wallet.balance

    if (
      Number(balance) < Number(data.quantity) &&
      data.debitOption !== 'OrderCorrection'
    ) {
      throw new BadRequestException('Saldo unsuficiente!')
    }

    await this.wallet.addDebit(data, wallet)

    return await this.prisma.walletDebit.create({
      data,
    })
  }

  async refundDebit(id: string, refunded: number): Promise<WalletDebit> {
    const findDebit = await this.prisma.walletDebit.findUnique({
      where: { id },
    })

    if (!findDebit) throw new NotFoundException('Debit not found')

    return await this.prisma.walletDebit.update({
      where: { id },
      data: {
        refunded: Number(findDebit.refunded) + refunded,
      },
    })
  }

  async update(id: string, data: Prisma.WalletDebitUpdateInput) {
    const findDebit = await this.prisma.walletDebit.findUnique({
      where: { id },
    })

    if (!findDebit) throw new NotFoundException('Debit not found')

    return await this.prisma.walletDebit.update({
      where: { id },
      data,
    })
  }

  async delete(id: string) {
    const findDebit = await this.prisma.walletDebit.findUnique({
      where: { id },
    })

    if (!findDebit) throw new NotFoundException('Debit not found')

    await this.prisma.walletDebit.delete({
      where: { id },
    })
  }
}

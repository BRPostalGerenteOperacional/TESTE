import { PaymentOption } from '@prisma/client'
export interface CreateCreditDTO {
  quantity: number
  observation?: string
  adminId?: number
  paymentOption: PaymentOption
  externalPaymentId?: string
  payedAt?: Date
  walletId: string
}

import { Decimal, DecimalJsLike } from '@prisma/client/runtime'

export interface AddCreditDTO {
  quantity: string | number | Decimal | DecimalJsLike
  observation?: string
  adminId?: number
  walletId: string | number | Decimal | DecimalJsLike
}

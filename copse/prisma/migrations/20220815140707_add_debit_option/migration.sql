-- CreateEnum
CREATE TYPE "DebitOption" AS ENUM ('NormalDebit', 'OrderCorrection');

-- AlterTable
ALTER TABLE "wallet_debit" ADD COLUMN     "debitOption" "DebitOption" NOT NULL DEFAULT 'NormalDebit';

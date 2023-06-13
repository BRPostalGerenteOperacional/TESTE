-- AlterTable
ALTER TABLE "wallet_credit" ADD COLUMN     "refundDebitId" UUID;

-- AddForeignKey
ALTER TABLE "wallet_credit" ADD CONSTRAINT "wallet_credit_refundDebitId_fkey" FOREIGN KEY ("refundDebitId") REFERENCES "wallet_debit"("id") ON DELETE SET NULL ON UPDATE CASCADE;

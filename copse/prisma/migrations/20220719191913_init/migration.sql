-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('CREDIT', 'DEBIT');

-- CreateEnum
CREATE TYPE "PaymentOption" AS ENUM ('PayPal', 'PagSeguro', 'PIX', 'Boleto');

-- CreateTable
CREATE TABLE "wallets" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ownerId" INTEGER NOT NULL,
    "balance" MONEY DEFAULT 0.00,

    CONSTRAINT "wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallet_credit" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "TransactionType" NOT NULL DEFAULT 'CREDIT',
    "quantity" MONEY NOT NULL,
    "observation" TEXT,
    "adminId" INTEGER,
    "payedAt" TIMESTAMP(3),
    "lastEditBy" TEXT,
    "paymentOption" "PaymentOption" NOT NULL,
    "externalPaymentId" TEXT,
    "walletId" UUID NOT NULL,

    CONSTRAINT "wallet_credit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallet_debit" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "TransactionType" NOT NULL DEFAULT 'DEBIT',
    "quantity" MONEY NOT NULL,
    "observation" TEXT,
    "laravelOrderId" INTEGER NOT NULL,
    "walletId" UUID NOT NULL,

    CONSTRAINT "wallet_debit_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "wallets_ownerId_key" ON "wallets"("ownerId");

-- AddForeignKey
ALTER TABLE "wallet_credit" ADD CONSTRAINT "wallet_credit_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_debit" ADD CONSTRAINT "wallet_debit_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

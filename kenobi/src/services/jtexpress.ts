import { Logger } from '@nestjs/common'
import axios from 'axios'

const logger = new Logger('JT Express')

export const jtIntegration = axios.create({
  baseURL: process.env.INT_URL_JT,
})

export const jtIntegrationDate = {
  token: process.env.AUTH_JT,
}

export const JTEndPoints = {
  addOrder: '/jt/order/addOrder',
  cancelOrder: '/jt/order/cancelOrder',
  getOrders: '/jt/order/getOrders',
  trace: '/jt/logistics/trace',
}

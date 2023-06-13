export default class UpdateRecalculatedShipmentDTO {
  objectData: {
    width: number
    height: number
    length: number
    weight: number
  }
  shipmentId: number
  newAmount: number
  shippedAt: Date
  orderId: number
}

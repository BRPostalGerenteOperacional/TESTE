export default class CorreiosPlpDataDTO {
  weight: string
  chargedValue: string
  senderZipCode: string
  senderUf: string
  recipientZipCode: string
  captureData: string
  dimensions: CorreiosPLPDimensionsDTO
}

export class CorreiosPLPDimensionsDTO {
  height: string
  width: string
  length: string
}

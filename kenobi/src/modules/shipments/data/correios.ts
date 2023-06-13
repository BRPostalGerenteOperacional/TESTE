import SIGEP = require('sigep-js')
import CorreiosPlpDataDTO from '../dto/CorreiosPlpData.dto'

const sigep = SIGEP.init({
  identificador: process.env.CORREIOS_CNPJ,
  usuario: process.env.CORREIOS_USER,
  senha: process.env.CORREIOS_PASS,
  codAdministrativo: process.env.CORREIOS_ADMINCODE,
  idContrato: process.env.CORREIOS_CONTRACT,
  idCartaoPostagem: process.env.CORREIOS_POSTCARD,
})

interface CorreiosElement {
  type: string
  name: string
  elements: CorreiosElement[] | CorreiosSubElement
}

interface CorreiosSubElement {
  type: string
  name: string

  elements: [
    {
      type: string
      text?: string
      cdata?: string
    }
  ]
}

function filterBigElement(field: string, elements: any): CorreiosElement {
  return elements.find((element: CorreiosElement): CorreiosElement => {
    if (element.name === field) return element
  })
}

function filterChildElement(field: string, elements: any, typeWanted: string) {
  const element = elements.find((element: CorreiosElement) => {
    return element.name === field
  })

  return element.elements[0][typeWanted]
}

export default async function getPlpData(plp: string): Promise<CorreiosPlpDataDTO> {
  try {
    const plpData = await sigep.solicitaJsonPlp(plp)
    let correiosObject = null

    if (plpData) {
      const parsed = JSON.parse(plpData)

      const postalObject = filterBigElement('objeto_postal', parsed.elements[0].elements)
      const objectDimension = filterBigElement('dimensao_objeto', postalObject.elements)
      const remetente = filterBigElement('remetente', parsed.elements[0].elements)
      const nacional = filterBigElement('nacional', postalObject.elements)

      const height = filterChildElement(
        'dimensao_altura',
        objectDimension.elements,
        'text'
      )
      const width = filterChildElement(
        'dimensao_largura',
        objectDimension.elements,
        'text'
      )
      const length = filterChildElement(
        'dimensao_comprimento',
        objectDimension.elements,
        'text'
      )

      correiosObject = {
        weight: filterChildElement('peso', postalObject.elements, 'text'),
        dimensions: {
          width: width.replace(',', '.'),
          height: height.replace(',', '.'),
          length: length.replace(',', '.'),
        },

        chargedValue: filterChildElement('valor_cobrado', postalObject.elements, 'text'),
        senderZipCode: filterChildElement('cep_remetente', remetente.elements, 'cdata'),
        senderUf: filterChildElement('uf_remetente', remetente.elements, 'text'),
        recipientZipCode: filterChildElement(
          'cep_destinatario',
          nacional.elements,
          'cdata'
        ),
        captureData: filterChildElement('data_captacao', postalObject.elements, 'text'),
      } as CorreiosPlpDataDTO
    }

    return correiosObject
  } catch (error) {
    // do Something
  }
}

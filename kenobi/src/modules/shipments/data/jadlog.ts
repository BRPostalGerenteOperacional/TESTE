import { jadlogApi } from 'src/services/jadlog'

export default async function trackObject(objectToTrack: string) {
  try {
    const response = await jadlogApi.request({
      method: 'POST',
      url: '/tracking/consultar',
      headers: {
        Authorization: `Bearer ${process.env.JADLOG_TOKEN}`,
      },
      data: {
        consulta: [{ shipmentId: objectToTrack }],
      },
    })

    return response.data
  } catch (error) {
    // do something
  }
}

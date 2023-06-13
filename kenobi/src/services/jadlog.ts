import axios from 'axios'

export const jadlogApi = axios.create({
  baseURL: process.env.JADLOG_URL,
})

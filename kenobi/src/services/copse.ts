import axios from 'axios'

export const copse = axios.create({ baseURL: process.env.COPSE_URL })

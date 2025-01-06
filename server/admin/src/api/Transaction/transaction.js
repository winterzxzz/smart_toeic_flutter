import axios from 'axios'
import { API_URL } from '../constantsAPI'

export const getTransactions = async (type) => {
  const response = await axios.get(`${API_URL}/api/admin/transaction/${type}`, {
    withCredentials: true,
    headers: { 'Content-Type': 'application/json' },
  })
  return response.data
}

import { getToken } from './token'

async function sendRequest (url: string, data: object = {}): Promise<Response> {
  const token = getToken()
  return await fetch(url, {
    method: 'post',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': token
    },
    body: JSON.stringify(data)
  })
}

export { sendRequest }

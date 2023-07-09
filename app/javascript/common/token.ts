const getToken = (): string => {
  const tokenElm = document.querySelector('meta[name="csrf-token"]')
  let token = ''
  if (tokenElm) {
    token = tokenElm.getAttribute('content') || ''
  }
  return token
}

export { getToken }

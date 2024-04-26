function sendMessage (message: string, color: string, icon: string): void {
  const notifContainer = document.getElementById('notifContainer')
  if (notifContainer === null) return

  const outerDiv = document.createElement('div')
  outerDiv.classList.add('px-6', 'py-4', 'backdrop-blur', 'rounded-4xl', 'border-[6px]', 'flex', 'gap-4', 'items-center', 'animate-fadeIn')
  outerDiv.style.borderColor = color
  outerDiv.style.backgroundColor = addAlpha(color, 0.5)

  const iconElm = document.createElement('i')
  iconElm.classList.add('fa-solid', icon)
  outerDiv.appendChild(iconElm)

  const messageElm = document.createElement('p')
  messageElm.innerText = message
  outerDiv.appendChild(messageElm)

  notifContainer.appendChild(outerDiv)

  setTimeout(() => {
    outerDiv.classList.remove('animate-fadeIn')
    outerDiv.classList.add('animate-fadeOut')
    setTimeout(() => outerDiv.remove(), 500)
  }, 6000)
}

function addAlpha (color: string, opacity: number) {
  // coerce values so it is between 0 and 1.
  const _opacity = Math.round(Math.min(Math.max(opacity ?? 1, 0), 1) * 255)
  return color + _opacity.toString(16).toUpperCase()
}

export { sendMessage }

function sendMessage (message: string, color: string, icon: string): void {
  const notifContainer = document.getElementById('notifContainer')
  if (notifContainer === null) return

  const outerDiv = document.createElement('div')
  outerDiv.classList.add('z-10', 'px-6', 'py-4', 'bg-white', 'rounded-lg', 'border-[6px]', 'flex', 'gap-4', 'items-center', 'animate-fadeIn')
  outerDiv.style.borderColor = color

  const iconElm = document.createElement('i')
  iconElm.classList.add('fa-solid', icon)
  iconElm.style.color = color
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

export { sendMessage }

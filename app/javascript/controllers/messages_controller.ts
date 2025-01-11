import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="messages"
export default class extends Controller {
  declare messagesContainer: HTMLElement
  declare observer: MutationObserver

  connect () {
    this.messagesContainer = this.element as HTMLElement

    const flashMessages = this.messagesContainer.querySelectorAll('div')
    flashMessages.forEach((message) => {
      this.loadFadeOut(message)
    })

    this.observer = new MutationObserver(this.callback.bind(this))
    const config = {
      childList: true,
      subtree: true
    }
    this.observer.observe(this.messagesContainer, config)
  }

  callback (mutationList: MutationRecord[]) {
    for (const mutation of mutationList) {
      if (mutation.type === 'childList') {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            this.loadFadeOut(node as HTMLElement)
          }
        })
      }
    }
  }

  loadFadeOut (element: HTMLElement) {
    setTimeout(() => {
      element.classList.remove('animate-fadeIn')
      element.classList.add('animate-fadeOut')
      setTimeout(() => element.remove(), 500)
    }, 6000)
  }
}

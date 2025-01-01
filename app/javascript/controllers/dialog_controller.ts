import { Controller } from '@hotwired/stimulus'
import { HTMLEvent } from '../types/html_event'

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ['dialog']

  static values = { togglerClass: String }

  declare readonly dialogTarget: HTMLDialogElement

  declare togglerClassValue: string

  connect (): void {
    if (this.togglerAvailable()) {
      const togglers = document.getElementsByClassName(this.togglerClassValue)
      Array.from(togglers).forEach((toggler) => {
        toggler.addEventListener('click', () => {
          this.dialogTarget.showModal()
          document.documentElement.style.overflow = 'hidden'
        })
      })
    }

    this.dialogTarget.addEventListener('close', () => { document.documentElement.style.overflow = '' })
  }

  disconnect (): void {
    this.dialogTarget.close()
  }

  click (event: HTMLEvent) {
    if (event.target === this.dialogTarget) {
      this.dialogTarget.close()
    }
  }

  togglerAvailable (): boolean {
    return this.togglerClassValue !== null && this.togglerAvailable !== undefined && this.togglerClassValue !== ''
  }
}

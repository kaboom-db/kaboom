import { Controller } from '@hotwired/stimulus'
import { HTMLEvent } from '../types/html_event'

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ['dialog']

  static values = { togglerId: String }

  declare readonly dialogTarget: HTMLDialogElement

  declare togglerIdValue: string

  connect (): void {
    if (this.togglerAvailable()) {
      const toggler = document.getElementById(this.togglerIdValue)
      toggler?.addEventListener('click', () => {
        this.dialogTarget.showModal()
        document.documentElement.style.overflow = 'hidden'
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
    return this.togglerIdValue !== null && this.togglerAvailable !== undefined && this.togglerIdValue !== ''
  }
}

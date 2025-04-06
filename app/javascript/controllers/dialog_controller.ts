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
      const togglers = document.querySelectorAll<HTMLElement>(`.${this.togglerClassValue}`)
      Array.from(togglers).forEach((toggler) => {
        this.addToggler(toggler)
      })
    }

    document.addEventListener('turbo:before-frame-render', this.onDomChanged.bind(this))
    this.dialogTarget.addEventListener('close', () => { document.documentElement.style.overflow = '' })
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  onDomChanged (event: any) {
    const newTogglers = (event.detail.newFrame as HTMLElement).querySelectorAll<HTMLElement>(`.${this.togglerClassValue}`)
    Array.from(newTogglers).forEach((toggler) => {
      this.addToggler(toggler)
    })
  }

  addToggler (toggler: HTMLElement): void {
    toggler.addEventListener('click', () => {
      this.dialogTarget.showModal()
      document.documentElement.style.overflow = 'hidden'
    })
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

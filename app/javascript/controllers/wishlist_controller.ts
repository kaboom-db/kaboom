import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'

// Connects to data-controller="wishlist"
export default class extends Controller {
  // static targets = ['button', 'icon', 'dialog', 'readAtSubmit', 'readAtInput', 'error']
  static targets = ['button', 'icon']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement
  // declare readonly dialogTarget: HTMLDialogElement
  // declare readonly readAtSubmitTarget: HTMLButtonElement
  // declare readonly readAtInputTarget: HTMLInputElement
  // declare readonly errorTarget: HTMLElement

  declare statusValue: boolean
  declare baseurlValue: string

  WISHLIST_BUTTON_CLASSES = ['bg-[#fdbd7d]']
  UNWISHLIST_BUTTON_CLASSES = ['group', 'hover:bg-[#fdbd7d]']

  WISHLIST_ICON_CLASSES = ['text-white']
  UNWISHLIST_ICON_CLASSES = ['text-[#fdbd7d', 'group-hover:text-white']

  connect (): void {
    this.updateClasses()
  }

  setStatus (newStatus: boolean): void {
    this.statusValue = newStatus
    this.updateClasses()
  }

  async trigger (): Promise<void> {
    try {
      const response = await sendRequest(`${this.baseurlValue}/wishlist`)
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        if (json.success) {
          this.setStatus(true)
        }
      }
    } catch (error) {
      console.log(error)
    }
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.UNWISHLIST_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.WISHLIST_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.UNWISHLIST_ICON_CLASSES)
      this.iconTarget.classList.add(...this.WISHLIST_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.UNWISHLIST_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.WISHLIST_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.UNWISHLIST_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.WISHLIST_ICON_CLASSES)
    }
  }
}

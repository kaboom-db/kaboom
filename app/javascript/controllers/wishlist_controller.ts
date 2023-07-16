import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'
import { sendMessage } from '../common/sendMessage'

// Connects to data-controller="wishlist"
export default class extends Controller {
  static targets = ['button', 'icon']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement

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
    const url = this.statusValue ? `${this.baseurlValue}/unwishlist` : `${this.baseurlValue}/wishlist`

    try {
      const response = await sendRequest(url)
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        if (json.success) {
          this.setStatus(json.wishlisted)
          sendMessage(json.message, '#fdbd7d', 'fa-cake-candles')
        } else {
          sendMessage(json.message, 'red', 'fa-cake-candles')
        }
      } else {
        throw Error('Unsuccessful response')
      }
    } catch (error) {
      console.log(error)
      sendMessage(`Could not ${this.statusValue ? 'unwishlist' : 'wishlist'} this.`, 'red', 'fa-cake-candles')
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

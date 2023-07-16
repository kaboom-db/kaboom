import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'
import { sendMessage } from '../common/sendMessage'

// Connects to data-controller="favourite"
export default class extends Controller {
  static targets = ['button', 'icon']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement

  declare statusValue: boolean
  declare baseurlValue: string

  FAVOURITE_BUTTON_CLASSES = ['bg-[#ff85a2]']
  UNFAVOURITE_BUTTON_CLASSES = ['group', 'hover:bg-[#ff85a2]']

  FAVOURITE_ICON_CLASSES = ['text-white']
  UNFAVOURITE_ICON_CLASSES = ['text-[#ff85a2', 'group-hover:text-white']

  connect (): void {
    this.updateClasses()
  }

  setStatus (newStatus: boolean): void {
    this.statusValue = newStatus
    this.updateClasses()
  }

  async trigger (): Promise<void> {
    const url = this.statusValue ? `${this.baseurlValue}/unfavourite` : `${this.baseurlValue}/favourite`

    try {
      const response = await sendRequest(url)
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        if (json.success) {
          this.setStatus(json.favourited)
          sendMessage(json.message, '#ff85a2', 'fa-heart')
        } else {
          sendMessage(json.message, 'red', 'fa-heart')
        }
      } else {
        throw Error('Unsuccessful response')
      }
    } catch (error) {
      console.log(error)
      sendMessage(`Could not ${this.statusValue ? 'unfavourite' : 'favourite'} this.`, 'red', 'fa-heart')
    }
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.UNFAVOURITE_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.FAVOURITE_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.UNFAVOURITE_ICON_CLASSES)
      this.iconTarget.classList.add(...this.FAVOURITE_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.UNFAVOURITE_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.FAVOURITE_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.UNFAVOURITE_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.FAVOURITE_ICON_CLASSES)
    }
  }
}

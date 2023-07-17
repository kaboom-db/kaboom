import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'
import { sendMessage } from '../common/sendMessage'

// Connects to data-controller="collect"
export default class extends Controller {
  static targets = ['button', 'icon', 'dialog', 'collectedOnSubmit', 'collectedOnInput', 'error']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement
  declare readonly dialogTarget: HTMLDialogElement
  declare readonly collectedOnSubmitTarget: HTMLButtonElement
  declare readonly collectedOnInputTarget: HTMLInputElement
  declare readonly errorTarget: HTMLElement

  declare statusValue: boolean
  declare baseurlValue: string

  COLLECT_BUTTON_CLASSES = ['bg-[#47bcea]']
  UNCOLLECT_BUTTON_CLASSES = ['group', 'hover:bg-[#47bcea]']

  COLLECT_ICON_CLASSES = ['text-white']
  UNCOLLECT_ICON_CLASSES = ['text-[#47bcea]', 'group-hover:text-white']

  connect (): void {
    this.updateClasses()
  }

  setStatus (newStatus: boolean): void {
    this.statusValue = newStatus
    this.updateClasses()
  }

  async trigger (): Promise<void> {
    const date = new Date()
    this.collectedOnInputTarget.value = date.toISOString().substring(0, 10)

    if (this.statusValue) {
      await this.markAsUncollected()
    } else {
      this.dialogTarget.showModal()
    }
  }

  async markAsUncollected (): Promise<void> {
    try {
      const response = await sendRequest(`${this.baseurlValue}/uncollect`)
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        if (json.success) {
          this.setStatus(json.wishlisted)
          sendMessage(json.message, '#47bcea', 'fa-book-open')
        } else {
          sendMessage(json.message, 'red', 'fa-book-open')
        }
      } else {
        throw Error('Unsuccessful response')
      }
    } catch (error) {
      console.log(error)
      sendMessage('Could not uncollect this.', 'red', 'fa-book-open')
    }
  }

  async markAsCollected (): Promise<void> {
    this.errorTarget.classList.add('hidden')
    try {
      const response = await sendRequest(`${this.baseurlValue}/collect`, { collected_on: this.collectedOnInputTarget.value })
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        if (json.success) {
          this.setStatus(json.has_collected)
          sendMessage(json.message, '#47bcea', 'fa-book-open')
          this.closeDialog()
        } else {
          this.errorTarget.classList.remove('hidden')
        }
      } else {
        this.errorTarget.classList.remove('hidden')
      }
    } catch (error) {
      console.log(error)
    }
  }

  closeDialog (): void {
    this.dialogTarget.close()
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.UNCOLLECT_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.COLLECT_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.UNCOLLECT_ICON_CLASSES)
      this.iconTarget.classList.add(...this.COLLECT_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.UNCOLLECT_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.COLLECT_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.UNCOLLECT_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.COLLECT_ICON_CLASSES)
    }
  }
}

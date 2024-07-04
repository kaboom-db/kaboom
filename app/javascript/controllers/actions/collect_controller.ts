import BaseActionController from './base_action_controller'
import { sendMessage } from '../../common/sendMessage'
import { ResponseData } from '../../types/response_data'

interface CollectData extends ResponseData {
  has_collected: boolean
}

// Connects to data-controller="collect"
export default class extends BaseActionController {
  static targets = ['dialog', 'collectedOnSubmit', 'collectedOnInput', 'pricePaidInput', 'error']

  declare readonly dialogTarget: HTMLDialogElement
  declare readonly collectedOnSubmitTarget: HTMLButtonElement
  declare readonly collectedOnInputTarget: HTMLInputElement
  declare readonly pricePaidInputTarget: HTMLInputElement
  declare readonly errorTarget: HTMLElement

  connect (): void {
    this.ON_BUTTON_CLASSES = ['!bg-[#47bcea]']
    this.OFF_BUTTON_CLASSES = ['group', 'hover:bg-[#47bcea]', 'bg-gray-100']

    this.ON_ICON_CLASSES = ['text-white']
    this.OFF_ICON_CLASSES = ['text-[#47bcea]', 'group-hover:text-white']

    super.connect()
  }

  async trigger (): Promise<void> {
    const date = new Date()
    this.collectedOnInputTarget.value = date.toISOString().substring(0, 10)

    if (this.statusValue) {
      this.sendRequest(`${this.baseurlValue}/uncollect`, {}, this.handleData.bind(this), this.handleError.bind(this))
    } else {
      this.dialogTarget.showModal()
    }
  }

  handleError (error: Error): void {
    console.log(error)
    if (this.statusValue) {
      sendMessage('Could not uncollect this.', 'red', 'fa-book-open')
    } else {
      this.errorTarget.classList.remove('hidden')
    }
  }

  handleData (data: ResponseData): void {
    const response = data as CollectData

    if (response.success) {
      this.setStatus(response.has_collected)
      sendMessage(response.message, '#47bcea', 'fa-book-open')

      this.closeDialog()
    } else {
      if (this.statusValue) {
        sendMessage(response.message, 'red', 'fa-book-open')
      } else {
        this.errorTarget.classList.remove('hidden')
      }
    }
  }

  async markAsCollected (): Promise<void> {
    this.errorTarget.classList.add('hidden')
    const pricePaid = this.pricePaidInputTarget.value === '' ? '0' : this.pricePaidInputTarget.value
    const data = { collected_on: this.collectedOnInputTarget.value, price_paid: pricePaid }
    this.sendRequest(`${this.baseurlValue}/collect`, data, this.handleData.bind(this), this.handleError.bind(this))
  }

  closeDialog (): void {
    if (this.dialogTarget.open) this.dialogTarget.close()
  }
}

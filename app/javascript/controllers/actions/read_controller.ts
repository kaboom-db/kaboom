import BaseActionController from './base_action_controller'
import { convertToUtc } from '../../common/dates'
import { sendMessage } from '../../common/sendMessage'
import { ResponseData } from '../../types/response_data'

interface ReadData extends ResponseData {
  read_count: number
}

// Connects to data-controller="read"
export default class extends BaseActionController {
  static targets = ['dialog', 'readAtSubmit', 'readAtInput', 'error']

  declare readonly dialogTarget: HTMLDialogElement
  declare readonly readAtSubmitTarget: HTMLButtonElement
  declare readonly readAtInputTarget: HTMLInputElement
  declare readonly errorTarget: HTMLElement

  connect (): void {
    this.ON_BUTTON_CLASSES = ['!bg-[#ff6961]']
    this.OFF_BUTTON_CLASSES = ['group', 'hover:bg-[#ff6961]', 'bg-gray-100']

    this.ON_ICON_CLASSES = ['text-white']
    this.OFF_ICON_CLASSES = ['text-[#ff6961]', 'group-hover:text-white']

    super.connect()
  }

  trigger (): void {
    const date = new Date()
    date.setMinutes(date.getMinutes() - date.getTimezoneOffset())
    this.readAtInputTarget.value = date.toISOString().slice(0, -8)

    this.dialogTarget.showModal()
  }

  markAsRead (): void {
    this.errorTarget.classList.add('hidden')
    const readAt = convertToUtc(this.readAtInputTarget.value)
    const url = `${this.baseurlValue}/read`
    this.sendRequest(url, { read_at: readAt }, this.handleData.bind(this), this.handleError.bind(this))
  }

  handleError (error: Error): void {
    console.log(error)
    this.errorTarget.classList.remove('hidden')
  }

  handleData (data: ResponseData): void {
    const response = data as ReadData

    this.setStatus(response.read_count > 0)
    if (response.success) {
      sendMessage(response.message, '#ff6961', 'fa-check')
      this.closeDialog()
    } else {
      this.errorTarget.classList.remove('hidden')
    }
  }

  closeDialog (): void {
    this.dialogTarget.close()
  }
}

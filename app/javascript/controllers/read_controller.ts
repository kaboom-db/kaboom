import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'
import { convertToUtc } from '../common/dates'

// Connects to data-controller="read"
export default class extends Controller {
  static targets = ['button', 'icon', 'dialog', 'readAtSubmit', 'readAtInput']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement
  declare readonly dialogTarget: HTMLDialogElement
  declare readonly readAtSubmitTarget: HTMLButtonElement
  declare readonly readAtInputTarget: HTMLInputElement

  declare statusValue: boolean
  declare baseurlValue: string

  READ_BUTTON_CLASSES = ['bg-[#ff6961]']
  UNREAD_BUTTON_CLASSES = ['group', 'hover:bg-[#ff6961]']

  READ_ICON_CLASSES = ['text-white']
  UNREAD_ICON_CLASSES = ['text-[#ff6961', 'group-hover:text-white']

  connect (): void {
    const date = new Date()
    date.setMinutes(date.getMinutes() - date.getTimezoneOffset())
    this.readAtInputTarget.value = date.toISOString().slice(0, -8)

    this.updateClasses()
  }

  setStatus (newStatus: boolean): void {
    this.statusValue = newStatus
    this.updateClasses()
  }

  trigger (): void {
    this.dialogTarget.showModal()
  }

  async markAsRead (): Promise<void> {
    try {
      const readAt = convertToUtc(this.readAtInputTarget.value)
      const response = await sendRequest(`${this.baseurlValue}/read`, { read_at: readAt })
      console.log(await response.json())
      this.setStatus(true)
      this.closeDialog()
    } catch (error) {
      console.log(error)
    }
  }

  closeDialog (): void {
    this.dialogTarget.close()
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.UNREAD_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.READ_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.UNREAD_ICON_CLASSES)
      this.iconTarget.classList.add(...this.READ_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.UNREAD_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.READ_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.UNREAD_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.READ_ICON_CLASSES)
    }
  }
}

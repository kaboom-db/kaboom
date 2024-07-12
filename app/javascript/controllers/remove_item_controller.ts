import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'

export default class extends Controller {
  static targets = ['dialog', 'error']
  static values = { url: String, data: Object }

  declare readonly dialogTarget: HTMLDialogElement
  declare readonly errorTarget: HTMLElement

  declare urlValue: string
  declare dataValue: string

  declare hasDataValue: boolean

  canShowDialog = true

  trigger (): void {
    if (this.canShowDialog) {
      this.dialogTarget.showModal()
    }
  }

  closeDialog (): void {
    this.dialogTarget.close()
  }

  destroy (): void {
    this.canShowDialog = false
    this.element.classList.add('animate-fadeOut')
    setTimeout(() => this.element.remove(), 500)
  }

  async removeItem (): Promise<void> {
    try {
      const requestBody = this.hasDataValue ? this.dataValue : {}
      const response = await sendRequest(this.urlValue, requestBody)
      if (response.status === 200 || response.status === 204) {
        this.closeDialog()
        this.destroy()
      } else {
        this.errorTarget.classList.remove('hidden')
      }
    } catch (error) {
      console.log(error)
    }
  }
}

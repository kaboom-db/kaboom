import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'

export default class extends Controller {
  static targets = ['dialog', 'error']
  static values = { readId: String, baseurl: String }

  declare readonly dialogTarget: HTMLDialogElement
  declare readonly errorTarget: HTMLElement

  declare readIdValue: string
  declare baseurlValue: string

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

  async markAsUnread (): Promise<void> {
    try {
      const response = await sendRequest(`${this.baseurlValue}/unread`, { read_id: this.readIdValue })
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

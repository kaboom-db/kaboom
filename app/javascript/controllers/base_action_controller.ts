import { Controller } from '@hotwired/stimulus'
import { ResponseData } from '../types/response_data'
import { getToken } from '../common/token'

export default class extends Controller {
  static targets = ['button', 'icon']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement

  declare statusValue: boolean
  declare baseurlValue: string

  declare ON_BUTTON_CLASSES: Array<string>
  declare OFF_BUTTON_CLASSES: Array<string>

  declare ON_ICON_CLASSES: Array<string>
  declare OFF_ICON_CLASSES: Array<string>

  connect (): void {
    this.updateClasses()
  }

  setStatus (newStatus: boolean): void {
    this.statusValue = newStatus
    this.updateClasses()
  }

  sendRequestV2 (url: string, data: object = {}, handleData: (data: ResponseData) => void, handleError: (error: Error) => void): void {
    const token = getToken()
    const options = {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': token
      },
      body: JSON.stringify(data)
    }
    fetch(url, options).then(this.handleResponse).then(handleData).catch(handleError)
  }

  async handleResponse (response: Response) {
    const json = await response.json()
    return response.ok ? json : Promise.reject(json)
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.OFF_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.ON_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.OFF_ICON_CLASSES)
      this.iconTarget.classList.add(...this.ON_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.OFF_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.ON_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.OFF_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.ON_ICON_CLASSES)
    }
  }
}

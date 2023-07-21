import BaseActionController from './base_action_controller'
import { sendMessage } from '../../common/sendMessage'
import { ResponseData } from '../../types/response_data'

interface WishlistData extends ResponseData {
  wishlisted: boolean
}

// Connects to data-controller="wishlist"
export default class extends BaseActionController {
  connect (): void {
    this.ON_BUTTON_CLASSES = ['bg-[#fdbd7d]']
    this.OFF_BUTTON_CLASSES = ['group', 'hover:bg-[#fdbd7d]']

    this.ON_ICON_CLASSES = ['text-white']
    this.OFF_ICON_CLASSES = ['text-[#fdbd7d]', 'group-hover:text-white']

    super.connect()
  }

  trigger (): void {
    const url = this.statusValue ? `${this.baseurlValue}/unwishlist` : `${this.baseurlValue}/wishlist`
    this.sendRequest(url, {}, this.handleData.bind(this), this.handleError.bind(this))
  }

  handleError (error: Error): void {
    console.log(error)
    sendMessage(`Could not ${this.statusValue ? 'unwishlist' : 'wishlist'} this.`, 'red', 'fa-cake-candles')
  }

  handleData (data: ResponseData): void {
    const response = data as WishlistData

    if (response.success) {
      this.setStatus(response.wishlisted)
      sendMessage(response.message, '#fdbd7d', 'fa-cake-candles')
    } else {
      sendMessage(response.message, 'red', 'fa-cake-candles')
    }
  }
}

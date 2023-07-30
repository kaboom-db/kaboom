import BaseActionController from './base_action_controller'
import { sendMessage } from '../../common/sendMessage'
import { ResponseData } from '../../types/response_data'

interface FavouriteData extends ResponseData {
  favourited: boolean
}

// Connects to data-controller="favourite"
export default class extends BaseActionController {
  connect (): void {
    this.ON_BUTTON_CLASSES = ['bg-[#ff85a2]']
    this.OFF_BUTTON_CLASSES = ['group', 'hover:bg-[#ff85a2]', 'bg-white']

    this.ON_ICON_CLASSES = ['text-white']
    this.OFF_ICON_CLASSES = ['text-[#ff85a2]', 'group-hover:text-white']

    super.connect()
  }

  trigger (): void {
    const url = this.statusValue ? `${this.baseurlValue}/unfavourite` : `${this.baseurlValue}/favourite`
    this.sendRequest(url, {}, this.handleData.bind(this), this.handleError.bind(this))
  }

  handleError (error: Error): void {
    console.log(error)
    sendMessage(`Could not ${this.statusValue ? 'unfavourite' : 'favourite'} this.`, 'red', 'fa-heart')
  }

  handleData (data: ResponseData): void {
    const response = data as FavouriteData

    if (response.success) {
      this.setStatus(response.favourited)
      sendMessage(response.message, '#ff85a2', 'fa-heart')
    } else {
      sendMessage(response.message, 'red', 'fa-heart')
    }
  }
}

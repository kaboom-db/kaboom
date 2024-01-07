import { Controller } from '@hotwired/stimulus'
import * as noUiSlider from 'nouislider'
import { sendRequest } from '../common/request'
import { sendMessage } from '../common/sendMessage'

// Connects to data-controller="read-range"
export default class extends Controller {
  static targets = ['slider']
  static values = { chapterCount: Number, url: String }

  declare readonly sliderTarget: HTMLElement

  declare chapterCountValue: number
  declare urlValue: string

  declare slider: noUiSlider.API

  connect () {
    this.slider = noUiSlider.create(this.sliderTarget, {
      start: [1, this.chapterCountValue],
      connect: true,
      range: {
        min: 1,
        max: this.chapterCountValue
      },
      tooltips: {
        to: function (numericValue) {
          return `Issue ${numericValue.toFixed(0)}`
        }
      },
      step: 1
    })
  }

  async submit () {
    const vals = this.slider.get() as string[]

    const start = Number(vals[0]).toFixed(0)
    const end = Number(vals[1]).toFixed(0)

    try {
      const response = await sendRequest(this.urlValue, { start, end })
      if (response.status === 200 || response.status === 204) {
        const json = await response.json()
        sendMessage(json.message, '#ff6961', 'fa-check')
      } else {
        sendMessage('An error occurred', 'red', 'fa-check')
      }
    } catch (error) {
      console.log(error)
      sendMessage('An error occurred', 'red', 'fa-check')
    }
  }
}

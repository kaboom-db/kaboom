import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="local-time"
export default class extends Controller {
  MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  connect () {
    const times = document.querySelectorAll<HTMLElement>('div[data-time]')
    times.forEach((element) => {
      const { time } = element.dataset
      const local = new Date(Date.parse(time || ''))
      element.innerText = `${local.getDate()} ${this.MONTHS[local.getMonth()]} ${local.getFullYear()} ${local.toLocaleTimeString().slice(0, -3)}`
    })
  }
}

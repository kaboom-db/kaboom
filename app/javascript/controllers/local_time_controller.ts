import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="local-time"
export default class extends Controller {
  static values = { utc: String }

  declare utcValue: string

  MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  connect () {
    const local = new Date(Date.parse(this.utcValue))
    this.element.textContent = `${local.getDate()} ${this.MONTHS[local.getMonth()]} ${local.getFullYear()} ${local.toLocaleTimeString().slice(0, -3)}`
  }
}

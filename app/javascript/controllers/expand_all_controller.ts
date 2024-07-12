import { Controller } from '@hotwired/stimulus'
import { HTMLEvent } from '../types/html_event'

// Connects to data-controller="expand-all"
export default class extends Controller {
  expanded = false

  toggle (event: HTMLEvent) {
    const { target } = event
    const details = Array.from(this.element.getElementsByTagName('details'))
    if (this.expanded) {
      details.forEach((element) => {
        if (element.open) {
          element.removeAttribute('open')
        }
      })
      target.innerHTML = 'Expand all'
    } else {
      details.forEach((element) => {
        if (!element.open) {
          element.setAttribute('open', '')
        }
      })
      target.innerHTML = 'Close all'
    }
    this.expanded = !this.expanded
  }
}

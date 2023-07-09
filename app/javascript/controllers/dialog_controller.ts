import { Controller } from '@hotwired/stimulus'
import { HTMLEvent } from '../types/html_event'

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ['dialog']

  declare readonly dialogTarget: HTMLDialogElement

  click (event: HTMLEvent) {
    if (event.target === this.dialogTarget) {
      this.dialogTarget.close()
    }
  }
}

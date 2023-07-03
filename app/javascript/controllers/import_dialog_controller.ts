import { Controller } from "@hotwired/stimulus"
import { HTMLEvent } from "../types/html_event"

// Connects to data-controller="import-dialog"
export default class extends Controller {
  static targets = ["dialog"]

  declare readonly dialogTarget: HTMLDialogElement

  connect() {
  }

  click(event: HTMLEvent) {
    if (event.target === this.dialogTarget) {
      this.dialogTarget.close()
    }
  }
}

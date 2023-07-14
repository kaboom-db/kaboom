import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="wishlist"
export default class extends Controller {
  // static targets = ['button', 'icon', 'dialog', 'readAtSubmit', 'readAtInput', 'error']
  static targets = ['button', 'icon']
  static values = { status: Boolean, baseurl: String }

  declare readonly buttonTarget: HTMLButtonElement
  declare readonly iconTarget: HTMLElement
  // declare readonly dialogTarget: HTMLDialogElement
  // declare readonly readAtSubmitTarget: HTMLButtonElement
  // declare readonly readAtInputTarget: HTMLInputElement
  // declare readonly errorTarget: HTMLElement

  declare statusValue: boolean
  declare baseurlValue: string

  READ_BUTTON_CLASSES = ['bg-[#fdbd7d]']
  UNREAD_BUTTON_CLASSES = ['group', 'hover:bg-[#fdbd7d]']

  READ_ICON_CLASSES = ['text-white']
  UNREAD_ICON_CLASSES = ['text-[#fdbd7d', 'group-hover:text-white']

  connect (): void {
    this.updateClasses()
  }

  trigger (): void {
    console.log('Triggered.')
  }

  updateClasses (): void {
    if (this.statusValue) {
      this.buttonTarget.classList.remove(...this.UNREAD_BUTTON_CLASSES)
      this.buttonTarget.classList.add(...this.READ_BUTTON_CLASSES)

      this.iconTarget.classList.remove(...this.UNREAD_ICON_CLASSES)
      this.iconTarget.classList.add(...this.READ_ICON_CLASSES)
    } else {
      this.buttonTarget.classList.add(...this.UNREAD_BUTTON_CLASSES)
      this.buttonTarget.classList.remove(...this.READ_BUTTON_CLASSES)

      this.iconTarget.classList.add(...this.UNREAD_ICON_CLASSES)
      this.iconTarget.classList.remove(...this.READ_ICON_CLASSES)
    }
  }
}

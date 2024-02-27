import Swiper from 'swiper'
import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="swiper"
export default class extends Controller {
  static targets = ['container', 'next', 'prev', 'pagination', 'slides']

  static values = { freeMode: { type: Boolean, default: false } }

  declare readonly containerTarget: HTMLElement
  readonly nextTarget: HTMLElement | undefined = undefined
  readonly prevTarget: HTMLElement | undefined = undefined
  readonly paginationTarget: HTMLElement | undefined = undefined

  declare readonly slidesTargets: HTMLElement[]

  declare freeModeValue: boolean

  declare swiper: Swiper

  connect () {
    this.swiper = new Swiper(this.containerTarget, {
      direction: 'horizontal',
      loop: this.slidesTargets.length > 1,
      spaceBetween: 20,
      freeMode: this.freeModeValue,
      slidesPerView: 'auto',
      mousewheel: this.freeModeValue,
      navigation: {
        nextEl: this.nextTarget,
        prevEl: this.prevTarget
      },
      pagination: {
        el: this.paginationTarget,
        dynamicBullets: true
      }
    })
  }
}

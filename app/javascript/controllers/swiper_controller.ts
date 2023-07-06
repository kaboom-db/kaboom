import Swiper from 'swiper'
import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="swiper"
export default class extends Controller {
  static targets = ['container', 'next', 'prev', 'pagination']

  declare readonly containerTarget: HTMLElement
  declare readonly nextTarget: HTMLElement
  declare readonly prevTarget: HTMLElement
  declare readonly paginationTarget: HTMLElement

  declare swiper: Swiper

  connect () {
    this.swiper = new Swiper(this.containerTarget, {
      loop: true,
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

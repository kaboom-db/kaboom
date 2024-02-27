import Swiper from 'swiper'
import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="swiper"
export default class extends Controller {
  static targets = ['container', 'next', 'prev', 'pagination', 'slides']

  static values = { freeMode: { type: Boolean, default: false } }

  declare readonly containerTarget: HTMLElement
  declare readonly nextTarget: HTMLElement
  declare readonly prevTarget: HTMLElement
  declare readonly paginationTarget: HTMLElement

  declare readonly hasNextTarget: boolean
  declare readonly hasPrevTarget: boolean
  declare readonly hasPaginationTarget: boolean

  declare readonly slidesTargets: HTMLElement[]

  declare freeModeValue: boolean

  declare swiper: Swiper

  navigation () {
    if (this.hasNextTarget && this.hasPrevTarget) {
      return {
        nextEl: this.nextTarget,
        prevEl: this.prevTarget
      }
    }
    return {}
  }

  pagination () {
    if (this.hasPaginationTarget) {
      return {
        el: this.paginationTarget,
        dynamicBullets: true
      }
    }
    return {}
  }

  connect () {
    this.swiper = new Swiper(this.containerTarget, {
      direction: 'horizontal',
      loop: this.slidesTargets.length > 1,
      spaceBetween: 20,
      freeMode: this.freeModeValue,
      slidesPerView: 'auto',
      mousewheel: this.freeModeValue,
      navigation: this.navigation(),
      pagination: this.pagination()
    })
  }
}

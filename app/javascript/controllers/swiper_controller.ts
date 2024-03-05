import SwiperBase from './swiper_base'
import { SwiperOptions } from 'swiper/types/swiper-options'

// Connects to data-controller="swiper"
export default class extends SwiperBase {
  static targets = ['next', 'prev', 'pagination', 'slides']

  declare readonly nextTarget: HTMLElement
  declare readonly prevTarget: HTMLElement
  declare readonly paginationTarget: HTMLElement

  declare readonly slidesTargets: HTMLElement[]

  options (): SwiperOptions {
    return {
      loop: this.slidesTargets.length > 1,
      spaceBetween: 20,
      navigation: {
        nextEl: this.nextTarget,
        prevEl: this.prevTarget
      },
      pagination: {
        el: this.paginationTarget,
        dynamicBullets: true
      }
    }
  }
}

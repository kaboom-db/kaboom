import { SwiperOptions } from 'swiper/types/swiper-options'
import SwiperBase from './swiper_base'
import Swiper from 'swiper'

// Connects to data-controller="genre-swiper"
export default class extends SwiperBase {
  static targets = ['leadingFade', 'trailingFade']

  declare readonly leadingFadeTarget: HTMLElement
  declare readonly trailingFadeTarget: HTMLElement

  options (): SwiperOptions {
    return {
      spaceBetween: 10,
      freeMode: true,
      mousewheel: true,
      on: {
        sliderMove: this.updateFades.bind(this),
        scroll: this.updateFades.bind(this),
        transitionEnd: this.updateInterface.bind(this)
      }
    }
  }

  reachBeginning () {
    this.leadingFadeTarget.classList.remove('opacity-100')
    this.leadingFadeTarget.classList.add('opacity-0')
  }

  reachEnd () {
    this.trailingFadeTarget.classList.remove('opacity-100')
    this.trailingFadeTarget.classList.add('opacity-0')
  }

  updateFades (swiper: Swiper): void {
    this.updateInterface(swiper)
  }

  updateInterface (swiper: Swiper): void {
    this.leadingFadeTarget.classList.remove('opacity-0')
    this.trailingFadeTarget.classList.remove('opacity-0')
    this.leadingFadeTarget.classList.add('opacity-100')
    this.trailingFadeTarget.classList.add('opacity-100')

    if (swiper.isBeginning) {
      this.reachBeginning()
    }

    if (swiper.isEnd) {
      this.reachEnd()
    }
  }
}

import Swiper from 'swiper'
import { Controller } from '@hotwired/stimulus'
import { SwiperOptions } from 'swiper/types/swiper-options'

export default class extends Controller {
  static targets = ['container']

  declare readonly containerTarget: HTMLElement

  declare swiper: Swiper

  options (): SwiperOptions {
    return {}
  }

  connect () {
    this.swiper = new Swiper(this.containerTarget, {
      direction: 'horizontal',
      slidesPerView: 'auto',
      ...this.options()
    })
  }
}

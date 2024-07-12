import { Controller } from '@hotwired/stimulus'
import * as fuzzysort from 'fuzzysort'
import { HTMLEvent } from '../types/html_event'

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['item']

  declare readonly itemTargets: HTMLElement[]

  trigger (event: HTMLEvent): void {
    const target = event.target as HTMLInputElement
    const query = target.value

    if (query === '') {
      this.reset()
    } else {
      this.search(query)
    }
  }

  reset (): void {
    this.itemTargets.forEach((element) => {
      element.classList.remove('hidden')
    })
  }

  search (query: string): void {
    this.itemTargets.forEach((element) => {
      const { name } = element.dataset
      const result = fuzzysort.single(query, name ?? '')
      const score = result?.score ?? 0
      if (score >= 0.5) {
        element.classList.remove('hidden')
      } else {
        element.classList.add('hidden')
      }
    })
  }
}

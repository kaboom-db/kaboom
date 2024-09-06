import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="horizontal-stack-chart"
export default class extends Controller {
  static targets = ['name', 'sub', 'segment']

  declare readonly nameTarget: HTMLElement
  declare readonly subTarget: HTMLElement
  declare readonly segmentTargets: HTMLElement[]

  connect (): void {
    this.segmentTargets.forEach((element) => {
      element.addEventListener('mouseenter', () => {
        const { name, percentage, count } = element.dataset
        this.nameTarget.innerText = name ?? ''
        this.subTarget.innerText = `${percentage}% - ${count}`
      })
    })
  }
}

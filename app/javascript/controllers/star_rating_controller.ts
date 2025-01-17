import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = ['star', 'subheading']

  static values = { currentScore: Number }

  declare readonly starTargets: HTMLElement[]
  declare readonly subheadingTarget: HTMLElement

  declare currentScoreValue: number // Current score is 1-10

  SUBHEADINGS = [
    '1 - Abysmal',
    '2 - Terrible',
    '3 - Bad',
    '4 - Poor',
    '5 - Meh',
    '6 - Average',
    '7 - Good',
    '8 - Great',
    '9 - Amazing',
    '10 - Phenomenal!'
  ]

  connect (): void {
    if (this.currentScoreValue > 0) {
      this.highlightStars(this.currentScoreValue - 1)
    }

    this.starTargets.forEach((star: HTMLElement, index: number) => {
      star.addEventListener('mouseover', () => {
        this.highlightStars(index)
      })

      star.addEventListener('mouseout', () => {
        if (this.currentScoreValue === 0) {
          this.clearStars()
        } else {
          this.highlightStars(this.currentScoreValue - 1)
        }
      })

      star.addEventListener('click', () => {
        this.currentScoreValue = index + 1
        this.highlightStars(index)
      })
    })
  }

  highlightStars (index: number): void {
    this.subheadingTarget.innerText = this.SUBHEADINGS[index]
    this.starTargets.forEach((star, i) => {
      if (i <= index) {
        star.classList.add('text-yellow-300')
        star.classList.remove('text-gray-300')
      } else {
        star.classList.remove('text-yellow-300')
        star.classList.add('text-gray-300')
      }
    })
  }

  clearStars (): void {
    this.subheadingTarget.innerText = ''
    this.starTargets.forEach(star => {
      star.classList.remove('text-yellow-300')
      star.classList.add('text-gray-300')
    })
  }
}

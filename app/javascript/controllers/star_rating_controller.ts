import { Controller } from '@hotwired/stimulus'
import { sendRequest } from '../common/request'
import { sendMessage } from '../common/sendMessage'

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = ['star', 'subheading']

  static values = { currentScore: Number, url: String }

  declare readonly starTargets: HTMLElement[]
  declare readonly subheadingTarget: HTMLElement

  declare currentScoreValue: number // Current score is 1-10
  declare urlValue: string

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
        this.selectStar(index)
      })
    })
  }

  selectStar (index: number): void {
    sendRequest(this.urlValue, { rating: index + 1 })
      .then(this.handleResponse)
      .then((data) => {
        if (data.success) {
          this.currentScoreValue = index + 1
          this.highlightStars(index)
        } else {
          sendMessage('Could not submit rating.', 'red', 'fa-star')
        }
      })
      .catch(() => sendMessage('Could not submit rating.', 'red', 'fa-star'))
  }

  async handleResponse (response: Response) {
    const json = await response.json()
    return response.ok ? json : Promise.reject(json)
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
    this.subheadingTarget.innerText = 'Not rated'
    this.starTargets.forEach(star => {
      star.classList.remove('text-yellow-300')
      star.classList.add('text-gray-300')
    })
  }
}

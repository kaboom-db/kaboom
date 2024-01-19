import Chart from 'stimulus-chartjs'

// Connects to data-controller="history-chart"
export default class extends Chart {
  static values = { displayLegend: { type: Boolean, default: true } }

  declare displayLegendValue: boolean

  connect () {
    super.connect()
  }

  get defaultOptions () {
    return {
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom', display: this.displayLegendValue }
      }
    }
  }
}

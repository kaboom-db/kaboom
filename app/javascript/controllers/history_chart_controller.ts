import Chart from 'stimulus-chartjs'

// Connects to data-controller="history-chart"
export default class extends Chart {
  connect () {
    super.connect()
  }

  get defaultOptions () {
    return {
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom' }
      }
    }
  }
}

import Chart from 'stimulus-chartjs'
import {Chart as ChartJS} from 'chart.js'

// Connects to data-controller="chart"
export default class extends Chart {
  static values = { displayLegend: { type: Boolean, default: true } }

  declare displayLegendValue: boolean

  initialize () {
    super.initialize()

    ChartJS.register({
      id: 'noData',
      afterDraw: function(chart: { data: { datasets: string | any[]; }; ctx: any; width: any; height: any; clear: () => void; }) {
        if (chart.data.datasets.length === 0) {
          // No data is present
          var ctx = chart.ctx;
          var width = chart.width;
          var height = chart.height;
          chart.clear();

          ctx.save();
          ctx.textAlign = "center";
          ctx.textBaseline = "middle";
          ctx.font = "50px normal 'Montserrat'";
          ctx.fillStyle = "gray";
          ctx.fillText(
            "No data",
            width / 2,
            height / 2
          );
          ctx.restore();
        }
      }
    });
  }

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

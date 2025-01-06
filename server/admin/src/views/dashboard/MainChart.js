import React from 'react'
import PropTypes from 'prop-types'
import { CChart } from '@coreui/react-chartjs'

const MainChart = ({ timeRange, data }) => {
  return (
    <CChart
      type="bar"
      data={data}
      options={{
        maintainAspectRatio: false,
        height: 300,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            mode: 'index',
            intersect: false
          }
        },
        scales: {
          x: {
            grid: {
              drawOnChartArea: false,
            },
            stacked: false
          },
          y: {
            beginAtZero: true,
            ticks: {
              maxTicksLimit: 5,
              stepSize: Math.ceil(Math.max(...data.datasets[0].data) / 5),
            },
            stacked: false
          },
        },
        elements: {
          line: {
            tension: 0.4,
          },
          point: {
            radius: 0,
            hitRadius: 10,
            hoverRadius: 4,
            hoverBorderWidth: 3,
          },
        },
      }}
    />
  )
}

MainChart.propTypes = {
  timeRange: PropTypes.string,
  data: PropTypes.shape({
    datasets: PropTypes.arrayOf(PropTypes.shape({
      data: PropTypes.arrayOf(PropTypes.number)
    }))
  }).isRequired
}

export default MainChart

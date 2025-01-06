import React, { useEffect, useRef } from 'react'
import PropTypes from 'prop-types'

import {
  CRow,
  CCol,
  CDropdown,
  CDropdownMenu,
  CDropdownItem,
  CDropdownToggle,
  CWidgetStatsA,
} from '@coreui/react'
import { getStyle } from '@coreui/utils'
import { CChartBar, CChartLine } from '@coreui/react-chartjs'
import CIcon from '@coreui/icons-react'
import { cilArrowBottom, cilArrowTop, cilOptions } from '@coreui/icons'

import { formatCurrency } from '../../utils/formatCurrency'
function getPercentage(data) {
  // Check if array is empty or has less than 2 elements
  if (!data || data.length < 2) {
    return 0
  }

  const lastData = data[data.length - 1]
  const previousData = data[data.length - 2]

  // Handle case where firstData is 0
  if (previousData === 0) {
    return lastData === 0 ? 0 : Infinity
  }

  // Handle case where lastData is 0
  if (lastData === 0) {
    return -100
  }

  // Calculate percentage change
  return Math.round(((lastData - previousData) / previousData) * 100 * 100) / 100
}
const WidgetsDropdown = ({ userChartData, revenueChartData, examChartData }) => {
  const widgetChartRef1 = useRef(null)
  const widgetChartRef2 = useRef(null)
  console.log(userChartData)
  console.log(revenueChartData)
  console.log(examChartData)
  useEffect(() => {
    document.documentElement.addEventListener('ColorSchemeChange', () => {
      if (widgetChartRef1.current) {
        setTimeout(() => {
          widgetChartRef1.current.data.datasets[0].pointBackgroundColor = getStyle('--cui-primary')
          widgetChartRef1.current.update()
        })
      }

      if (widgetChartRef2.current) {
        setTimeout(() => {
          widgetChartRef2.current.data.datasets[0].pointBackgroundColor = getStyle('--cui-info')
          widgetChartRef2.current.update()
        })
      }
    })
  }, [widgetChartRef1, widgetChartRef2])

  return (
    <CRow xs={{ gutter: 4 }}>
      <CCol sm={6} xl={4} xxl={4}>
        <CWidgetStatsA
          color="primary"
          value={
            <>
              {userChartData.datasets[0].data[userChartData.datasets[0].data.length - 1]}
              <span className="fs-6 fw-normal">
                ( {getPercentage(userChartData.datasets[0].data)}%{' '}
                {getPercentage(userChartData.datasets[0].data) > 0 ? (
                  <CIcon icon={cilArrowTop} />
                ) : (
                  <CIcon icon={cilArrowBottom} />
                )}
                )
              </span>
            </>
          }
          title="Users"
          action={
            <CDropdown alignment="end">
              <CDropdownToggle color="transparent" caret={false} className="text-white p-0">
                <CIcon icon={cilOptions} />
              </CDropdownToggle>
              <CDropdownMenu>
                <CDropdownItem>Action</CDropdownItem>
                <CDropdownItem>Another action</CDropdownItem>
                <CDropdownItem>Something else here...</CDropdownItem>
                <CDropdownItem disabled>Disabled action</CDropdownItem>
              </CDropdownMenu>
            </CDropdown>
          }
          chart={
            <CChartLine
              className="mt-3"
              style={{ height: '70px' }}
              data={{
                // eslint-disable-next-line react/prop-types
                labels: userChartData.labels,
                datasets: [
                  {
                    label: 'data',
                    backgroundColor: 'rgba(255,255,255,.2)',
                    borderColor: 'rgba(255,255,255,.55)',
                    // eslint-disable-next-line react/prop-types
                    data: userChartData.datasets[0].data,
                    fill: true,
                  },
                ],
              }}
              options={{
                plugins: {
                  legend: {
                    display: false,
                  },
                },
                maintainAspectRatio: false,
                scales: {
                  x: {
                    display: false,
                  },
                  y: {
                    display: false,
                  },
                },
                elements: {
                  line: {
                    borderWidth: 2,
                    tension: 0.4,
                  },
                  point: {
                    radius: 0,
                    hitRadius: 10,
                    hoverRadius: 4,
                  },
                },
              }}
            />
          }
        />
      </CCol>
      <CCol sm={6} xl={4} xxl={4}>
        <CWidgetStatsA
          color="info"
          value={
            <>
              {formatCurrency(
                revenueChartData.datasets[0].data[revenueChartData.datasets[0].data.length - 1],
              )}
              <span className="fs-6 fw-normal">
                ( {getPercentage(revenueChartData.datasets[0].data)}%{' '}
                {getPercentage(revenueChartData.datasets[0].data) > 0 ? (
                  <CIcon icon={cilArrowTop} />
                ) : (
                  <CIcon icon={cilArrowBottom} />
                )}
                )
              </span>
            </>
          }
          title="Income"
          action={
            <CDropdown alignment="end">
              <CDropdownToggle color="transparent" caret={false} className="text-white p-0">
                <CIcon icon={cilOptions} />
              </CDropdownToggle>
              <CDropdownMenu>
                <CDropdownItem>Action</CDropdownItem>
                <CDropdownItem>Another action</CDropdownItem>
                <CDropdownItem>Something else here...</CDropdownItem>
                <CDropdownItem disabled>Disabled action</CDropdownItem>
              </CDropdownMenu>
            </CDropdown>
          }
          chart={
            <CChartLine
              className="mt-3"
              style={{ height: '70px' }}
              data={{
                // eslint-disable-next-line react/prop-types
                labels: revenueChartData.labels,
                datasets: [
                  {
                    label: 'data',
                    backgroundColor: 'rgba(255,255,255,.2)',
                    borderColor: 'rgba(255,255,255,.55)',
                    // eslint-disable-next-line react/prop-types
                    data: revenueChartData.datasets[0].data,
                    fill: true,
                  },
                ],
              }}
              options={{
                plugins: {
                  legend: {
                    display: false,
                  },
                },
                maintainAspectRatio: false,
                scales: {
                  x: {
                    display: false,
                  },
                  y: {
                    display: false,
                  },
                },
                elements: {
                  line: {
                    borderWidth: 2,
                    tension: 0.4,
                  },
                  point: {
                    radius: 0,
                    hitRadius: 10,
                    hoverRadius: 4,
                  },
                },
              }}
            />
          }
        />
      </CCol>
      <CCol sm={6} xl={4} xxl={4}>
        <CWidgetStatsA
          color="warning"
          value={
            <>
              {examChartData.datasets[0].data[examChartData.datasets[0].data.length - 1]}
              <span className="fs-6 fw-normal">
                ( {getPercentage(examChartData.datasets[0].data)}%{' '}
                {getPercentage(examChartData.datasets[0].data) > 0 ? (
                  <CIcon icon={cilArrowTop} />
                ) : (
                  <CIcon icon={cilArrowBottom} />
                )}
                )
              </span>
            </>
          }
          title="Exam Attempts"
          action={
            <CDropdown alignment="end">
              <CDropdownToggle color="transparent" caret={false} className="text-white p-0">
                <CIcon icon={cilOptions} />
              </CDropdownToggle>
              <CDropdownMenu>
                <CDropdownItem>Action</CDropdownItem>
                <CDropdownItem>Another action</CDropdownItem>
                <CDropdownItem>Something else here...</CDropdownItem>
                <CDropdownItem disabled>Disabled action</CDropdownItem>
              </CDropdownMenu>
            </CDropdown>
          }
          chart={
            <CChartLine
              className="mt-3"
              style={{ height: '70px' }}
              data={{
                // eslint-disable-next-line react/prop-types
                labels: examChartData.labels,
                datasets: [
                  {
                    label: 'data',
                    backgroundColor: 'rgba(255,255,255,.2)',
                    borderColor: 'rgba(255,255,255,.55)',
                    // eslint-disable-next-line react/prop-types
                    data: examChartData.datasets[0].data,
                    fill: true,
                  },
                ],
              }}
              options={{
                plugins: {
                  legend: {
                    display: false,
                  },
                },
                maintainAspectRatio: false,
                scales: {
                  x: {
                    display: false,
                  },
                  y: {
                    display: false,
                  },
                },
                elements: {
                  line: {
                    borderWidth: 2,
                    tension: 0.4,
                  },
                  point: {
                    radius: 0,
                    hitRadius: 10,
                    hoverRadius: 4,
                  },
                },
              }}
            />
          }
        />
      </CCol>
    </CRow>
  )
}

WidgetsDropdown.propTypes = {
  className: PropTypes.string,
  withCharts: PropTypes.bool,
}

export default WidgetsDropdown

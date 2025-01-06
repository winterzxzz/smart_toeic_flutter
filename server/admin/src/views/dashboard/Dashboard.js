import React, { useEffect, useState } from 'react'
import classNames from 'classnames'
import instance from '../../configs/axios.instance'
import { endpoint } from '../../api'
import {
  CButton,
  CButtonGroup,
  CCard,
  CCardBody,
  CCardFooter,
  CCol,
  CProgress,
  CRow,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilCloudDownload } from '@coreui/icons'

import WidgetsDropdown from '../widgets/WidgetsDropdown'
import MainChart from './MainChart'
import { formatCurrency } from '../../utils/formatCurrency'
import { formatNumber } from '../../utils/formatNumber'
import ProtectRouter from '../../wrapper/ProtectRouter'
// Chart data for each section
// Hàm lấy n năm gần nhất
function getLastYears(num) {
  const currentYear = new Date().getFullYear()
  const lastYears = []

  for (let i = 0; i < num; i++) {
    const year = currentYear - i
    lastYears.push(year.toString())
  }

  return lastYears.reverse() // Đảo ngược để có thứ tự từ cũ đến mới
}

// Hàm lấy n ngày gần nhất
function getLastDays(num) {
  const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  const currentDate = new Date()
  const lastDays = []

  for (let i = 0; i < num; i++) {
    const date = new Date(currentDate)
    date.setDate(currentDate.getDate() - i)

    lastDays.push(`${dayNames[date.getDay()]}, ${date.getDate()}/${date.getMonth() + 1}`)
  }

  return lastDays.reverse() // Đảo ngược để có thứ tự từ cũ đến mới
}

// Giữ nguyên hàm lấy tháng đã có
function getLastMonths(num) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ]
  const currentDate = new Date()
  const currentMonth = currentDate.getMonth()

  const lastMonths = []
  for (let i = 0; i < num; i++) {
    const monthIndex = (currentMonth - i + 12) % 12
    lastMonths.push(monthNames[monthIndex])
  }

  return lastMonths.reverse()
}

const userProgress = [
  {
    title: 'Total Users',
    value: formatNumber(29703),
    color: 'primary',
    description: 'Total registered users',
  },
  {
    title: 'Premium Users',
    value: formatNumber(8912),
    color: 'warning',
    description: 'Percentage of total users',
  },
]

const _userChartData = {
  labels: getLastMonths(7),
  connect: {
    upgrade: 0,
    new: 1,
  },
  datasets: [
    {
      label: 'Premium Users',
      backgroundColor: 'rgba(255,193,7,0.1)',
      borderColor: 'rgba(255,193,7,0.5)',
      pointHoverBackgroundColor: '#fff',
      borderWidth: 2,
      data: [8912, 8234, 7645, 7123, 6845, 6234, 5845],
      type: 'bar',
    },
    {
      label: 'New Users',
      backgroundColor: 'rgba(0,216,255,0.8)',
      borderColor: 'rgba(0,216,255,0.8)',
      data: [2123, 1897, 2045, 1678, 1890, 1654, 1789],
      type: 'bar',
    },
  ],
}

// Progress data for each section
const revenueProgress = [
  {
    title: 'Total Revenue',
    value: formatCurrency(0),
    percent: 100,
    color: 'primary',
    description: 'Total earnings',
  },
  {
    title: 'Number of transaction',
    value: 0,
    percent: 13,
    color: 'success',
    description: '',
  },
]

const examProgress = [
  {
    title: 'Total Attempts',
    value: formatNumber(15234),
    percent: 100,
    color: 'primary',
    description: 'All exam attempts',
  },
]

const _revenueChartData = {
  labels: getLastMonths(7),
  datasets: [
    {
      label: 'Total Revenue',
      backgroundColor: 'rgba(0,123,255,0.1)',
      borderColor: 'rgba(0,123,255,0.5)',
      pointHoverBackgroundColor: '#fff',
      borderWidth: 2,
      data: [0, 0, 0, 0, 0, 0, 0],
      type: 'line',
    },
  ],
}

const _examChartData = {
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  datasets: [
    {
      label: 'Total Attempts',
      backgroundColor: 'rgba(0,123,255,0.1)',
      borderColor: 'rgba(0,123,255,0.5)',
      pointHoverBackgroundColor: '#fff',
      borderWidth: 2,
      data: [0, 0, 0, 0, 0, 0, 0],
      type: 'line',
    },
  ],
}

function handleChartData(chartData, num, dataCount) {
  console.log(chartData, num, dataCount)
  let data = { ...chartData }
  data.datasets[num].data = dataCount
  return data
}
function handleProgressData(progressData, num, dataCount) {
  let data = { ...progressData }
  data[num].value = dataCount
  return data
}

const Dashboard = () => {
  const [timeRange, setTimeRange] = useState('Month')
  const [labels, setLabels] = useState(getLastMonths(7))
  const [userChartData, setUserChartData] = useState(_userChartData)
  const [examChartData, setExamChartData] = useState(_examChartData)
  const [revenueChartData, setRevenueChartData] = useState(_revenueChartData)
  const [userProgressData, setUserProgressData] = useState(userProgress)
  const [revenueProgressData, setRevenueProgressData] = useState(revenueProgress)
  const [examProgressData, setExamProgressData] = useState(examProgress)
  const handleTimeRangeChange = (range) => {
    setTimeRange(range)
  }
  function setLabelsToAllChart(labels) {
    console.log('set labels: ', labels)
    setUserChartData((prev) => ({ ...prev, labels }))
    setRevenueChartData((prev) => ({ ...prev, labels }))
    setExamChartData((prev) => ({ ...prev, labels }))
  }
  useEffect(() => {
    let step = 30
    let num = 7
    let labels = getLastMonths(num)
    if (timeRange === 'Month') {
      step = 30
      num = 7
      labels = getLastMonths(num)
    } else if (timeRange === 'Year') {
      step = 365
      num = 10
      labels = getLastYears(num)
    } else if (timeRange === 'Day') {
      step = 1
      num = 24
      labels = getLastDays(num)
    }
    setLabels(labels)
    async function fetchData() {
      const { data: upgradeUserData } = await instance.get(endpoint.userAnalyst.upgrade, {
        params: {
          step: step,
          num: num,
        },
      })
      const countUpgradeUserData = upgradeUserData.map((item) => item.count)
      const { data: newUserData } = await instance.get(endpoint.userAnalyst.new, {
        params: {
          step: step,
          num: num,
        },
      })

      const { data: progressUserData } = await instance.get(endpoint.userAnalyst.progress)
      const countNewUserData = newUserData.map((item) => item.count)
      setUserChartData(handleChartData(userChartData, 0, countUpgradeUserData))
      setUserChartData(handleChartData(userChartData, 1, countNewUserData))
      setUserProgressData(handleProgressData(userProgressData, 0, progressUserData.totalUser))
      setUserProgressData(handleProgressData(userProgressData, 1, progressUserData.premiumUser))
      const { data: newTransactionData } = await instance.get(endpoint.transactionAnalyst.new, {
        params: {
          step: step,
          num: num,
        },
      })
      const { data: progressTransactionData } = await instance.get(
        endpoint.transactionAnalyst.progress,
      )
      const countNewTransactionData = newTransactionData.map((item) => item.count)
      const amountNewTransactionData = newTransactionData.map((item) => item.totalAmount)
      setRevenueChartData(handleChartData(revenueChartData, 0, amountNewTransactionData))
      setRevenueProgressData(
        handleProgressData(
          revenueProgressData,
          0,
          formatCurrency(progressTransactionData.totalAmount),
        ),
      )
      setRevenueProgressData(
        handleProgressData(revenueProgressData, 1, progressTransactionData.totalTransaction),
      )
      const { data: newResultData } = await instance.get(endpoint.result.new, {
        params: {
          step: step,
          num: num,
        },
      })
      const { data: progressResultData } = await instance.get(endpoint.result.progress)
      const countNewResultData = newResultData.map((item) => item.count)
      setExamChartData(handleChartData(examChartData, 0, countNewResultData))
      setExamProgressData(handleProgressData(examProgressData, 0, progressResultData.totalResult))
      setLabelsToAllChart(labels)
    }
    fetchData()
  }, [timeRange])
  // useEffect(() => {
  //   setLabelsToAllChart(labels)
  // }, [labels])
  // Render statistics sections
  const renderStatisticsSection = (title, chartData, progressData) => (
    <CCard className="mb-4">
      <CCardBody>
        <CRow>
          <CCol sm={5}>
            <h4 className="card-title mb-0">{title}</h4>
            <div className="small text-body-secondary">
              {timeRange === 'Day' && 'Last 24 hours'}
              {timeRange === 'Month' && 'Last 30 days'}
              {timeRange === 'Year' && 'Last 12 months'}
            </div>
          </CCol>
          <CCol sm={7} className="d-none d-md-block">
            <CButton color="primary" className="float-end">
              <CIcon icon={cilCloudDownload} />
            </CButton>
            <CButtonGroup className="float-end me-3">
              {['Day', 'Month', 'Year'].map((value) => (
                <CButton
                  color="outline-secondary"
                  key={value}
                  className="mx-0"
                  active={value === timeRange}
                  onClick={() => handleTimeRangeChange(value)}
                >
                  {value}
                </CButton>
              ))}
            </CButtonGroup>
          </CCol>
        </CRow>
        <MainChart data={chartData} timeRange={timeRange} />
      </CCardBody>
      <CCardFooter>
        <CRow
          xs={{ cols: 1, gutter: 4 }}
          sm={{ cols: 2 }}
          lg={{ cols: 4 }}
          className="mb-2 text-center"
        >
          {progressData.map((item, index) => (
            <CCol key={index}>
              <div className="text-body-secondary">{item.title}</div>
              <div className="fw-semibold text-truncate">{item.value}</div>
              <div className="small text-body-secondary">{item.description}</div>
            </CCol>
          ))}
        </CRow>
      </CCardFooter>
    </CCard>
  )

  return (
    <>
      <WidgetsDropdown
        userChartData={userChartData}
        revenueChartData={revenueChartData}
        examChartData={examChartData}
        className="mb-4"
      />

      {/* User Statistics (existing) */}
      {userChartData && renderStatisticsSection('User Statistics', userChartData, userProgress)}

      {/* Revenue Statistics */}
      {revenueChartData &&
        renderStatisticsSection('Revenue Statistics', revenueChartData, revenueProgress)}

      {/* Exam Statistics */}
      {examChartData && renderStatisticsSection('Exam Statistics', examChartData, examProgress)}
    </>
  )
}
const ProtectedDashboard = () => {
  return (
    <ProtectRouter>
      <Dashboard />
    </ProtectRouter>
  )
}
export default ProtectedDashboard

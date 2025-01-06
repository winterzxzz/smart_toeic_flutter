import React, { useState, useEffect } from 'react'
import {
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
  CTable,
  CTableBody,
  CTableDataCell,
  CTableHead,
  CTableHeaderCell,
  CTableRow,
  CButton,
  CBadge,
  CFormInput,
  CInputGroup,
  CDropdown,
  CDropdownToggle,
  CDropdownMenu,
  CDropdownItem,
  CFormSelect,
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CWidgetStatsF,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import {
  cilDollar,
  cilPeople,
  cilCart,
  cilChartLine,
  cilSearch,
  cilFilter,
  cilUser,
} from '@coreui/icons'
import { useNavigate } from 'react-router-dom'
import { CChart } from '@coreui/react-chartjs'

import { formatCurrency } from '../../../utils/formatCurrency'
import { getTransactions } from '../../../api/Transaction/transaction'
import ProtectRouter from '../../../wrapper/ProtectRouter'
import { endpoint } from '../../../api'
import instance from '../../../configs/axios.instance'
import { formatDate, formatDateTime } from '../../../utils/formatDate'
import { toast } from 'react-toastify'

const _subscriptionData = {
  labels: ['Premium', 'Regular'],
  datasets: [
    {
      data: [60, 40],
      backgroundColor: ['#FF6384', '#36A2EB'],
      hoverBackgroundColor: ['#FF6384', '#36A2EB'],
    },
  ],
}

const Revenue = () => {
  const [filteredTransactions, setFilteredTransactions] = useState([])
  const [premiumUsers, setPremiumUsers] = useState(0)
  const [growthRate, setGrowthRate] = useState(0)
  const [newTransactions, setNewTransactions] = useState(0)
  const [totalRevenue, setTotalRevenue] = useState(0)
  const [searchTerm, setSearchTerm] = useState('')
  const [subscriptionData, setSubscriptionData] = useState(_subscriptionData)
  const [transactionCheck, setTransactionCheck] = useState({
    message: '',
    status: '',
  })
  const [filters, setFilters] = useState({
    status: '',
    package: '',
    dateRange: '',
    startDate: '',
    endDate: '',
  })
  const [viewModal, setViewModal] = useState(false)
  const [selectedTransaction, setSelectedTransaction] = useState(null)
  const transactionsPerPage = 5
  const [currentPage, setCurrentPage] = useState(1)
  const navigate = useNavigate()
  const [transactions, setTransactions] = useState([])
  const handlePageChange = (pageNumber) => {
    setCurrentPage(pageNumber)
  }
  const handleUpdateStatus = async (id) => {
    try {
      const { data } = await instance.post(endpoint.transaction.updateStatus, {
        id: id,
        status: transactionCheck.status,
      })
      setTransactions((prev) =>
        prev.map((transaction) =>
          transaction.providerId === id
            ? { ...transaction, status: transactionCheck.status }
            : transaction,
        ),
      )
      setSelectedTransaction((prev) => ({
        ...prev,
        status: transactionCheck.status,
      }))
      setTransactionCheck({
        message: '',
        status: '',
      })
      toast.success('Update status successfully')
    } catch (error) {
      toast.error('Update status failed')
    }
  }
  const handleCheckStatus = async (id) => {
    const { data } = await instance.get(endpoint.transaction.getStatus, {
      params: { transId: id },
    })
    setTransactionCheck({
      message: data.return_message,
      status: data.status,
    })
  }
  const handleCloseModal = () => {
    setViewModal(false)
    setTransactionCheck({
      message: '',
      status: '',
    })
  }
  const indexOfLastTransaction = currentPage * transactionsPerPage
  const indexOfFirstTransaction = indexOfLastTransaction - transactionsPerPage
  const currentTransactions = filteredTransactions.slice(
    indexOfFirstTransaction,
    indexOfLastTransaction,
  )
  useEffect(() => {
    const fetchTransactions = async () => {
      const { data } = await instance.get(endpoint.transaction.get)
      setTransactions(data)
    }
    fetchTransactions()
    const fetchData = async () => {
      const { data: userProgress } = await instance.get(endpoint.userAnalyst.progress)

      setPremiumUsers(userProgress.premiumUser)
      const { data: transactionProgress } = await instance.get(endpoint.transactionAnalyst.progress)

      const { data: transactionAnalyst } = await instance.get(endpoint.transactionAnalyst.new, {
        params: {
          step: 30,
          num: 2,
        },
      })
      const transactionAnalystDataThisMonth = transactionAnalyst[transactionAnalyst.length - 1]
      setNewTransactions(transactionAnalystDataThisMonth.count)
      setTotalRevenue(transactionProgress.totalAmount)
      setGrowthRate(transactionAnalystDataThisMonth.growthRate)
      setSubscriptionData((pre) => ({
        ...pre,
        datasets: [
          {
            ...pre.datasets[0],
            data: [userProgress.premiumUser, userProgress.totalUser - userProgress.premiumUser],
          },
        ],
      }))
    }
    fetchData()
    fetchRevenueData('last-7-months')
  }, [])

  // Search and Filter Logic
  useEffect(() => {
    let result = [...transactions]

    if (searchTerm) {
      result = result.filter(
        (transaction) =>
          transaction?.user?.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
          transaction?.user?.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
          transaction?.invoiceId?.toLowerCase().includes(searchTerm.toLowerCase()),
      )
    }

    if (filters.status) {
      result = result.filter((transaction) => transaction?.status === filters.status)
    }

    if (filters.package) {
      result = result.filter((transaction) => transaction?.package === filters.package)
    }

    if (filters.dateRange) {
      const today = new Date()
      const days = {
        last7days: 7,
        last30days: 30,
        last90days: 90,
      }
      const daysAgo = new Date(today.setDate(today.getDate() - days[filters.dateRange]))
      result = result.filter((transaction) => new Date(transaction?.date) >= daysAgo)
    } else if (filters.startDate && filters.endDate) {
      const start = new Date(filters.startDate)
      const end = new Date(filters.endDate)
      result = result.filter((transaction) => {
        const date = new Date(transaction?.createdAt)
        return date >= start && date <= end
      })
    }

    setFilteredTransactions(result)
  }, [transactions, searchTerm, filters])

  const handleFilterChange = (filterType, value) => {
    setFilters((prev) => ({
      ...prev,
      [filterType]: value,
    }))
  }

  // Charts data
  const [revenueData, setRevenueData] = useState({
    labels: [],
    datasets: [
      {
        label: 'Monthly Revenue',
        backgroundColor: 'rgba(0, 123, 255, 0.1)',
        borderColor: 'rgba(0, 123, 255, 1)',
        pointBackgroundColor: 'rgba(0, 123, 255, 1)',
        data: [],
      },
    ],
  })

  const fetchRevenueData = async (timeFrame) => {
    const data = await getTransactions(timeFrame)
    let labels = []
    let amounts = []

    if (timeFrame === 'last-7-years') {
      labels = data.map((item) => `${item._id.year}`)
      amounts = data.map((item) => item.totalAmount)
    } else {
      labels = data.map((item) =>
        timeFrame === 'last-7-days' ? `${item.date}` : `${item._id.month}/${item._id.year}`,
      )
      amounts = data.map((item) => item.totalAmount)
    }
    setRevenueData((prev) => ({
      ...prev,
      labels,
      datasets: [
        {
          ...prev.datasets[0],
          data: amounts,
        },
      ],
    }))
  }

  const handleTimeFrameChange = (timeFrame) => {
    fetchRevenueData(timeFrame)
  }

  useEffect(() => {
    if (!viewModal) {
      setTransactionCheck({
        message: '',
        status: '',
      })
    }
  }, [viewModal])
  return (
    <>
      <CRow>
        <CCol sm={6} lg={3}>
          <CWidgetStatsF
            className="mb-3"
            icon={<CIcon icon={cilDollar} height={24} />}
            title="Total Revenue"
            value={formatCurrency(totalRevenue)}
            color="primary"
          />
        </CCol>
        <CCol sm={6} lg={3}>
          <CWidgetStatsF
            className="mb-3"
            icon={<CIcon icon={cilPeople} height={24} />}
            title="Premium Users"
            value={premiumUsers}
            color="info"
          />
        </CCol>
        <CCol sm={6} lg={3}>
          <CWidgetStatsF
            className="mb-3"
            icon={<CIcon icon={cilCart} height={24} />}
            title="New Sales (30 days ago)"
            value={newTransactions}
            color="success"
          />
        </CCol>
        <CCol sm={6} lg={3}>
          <CWidgetStatsF
            className="mb-3"
            icon={<CIcon icon={cilChartLine} height={24} />}
            title="Growth Rate"
            value={growthRate + '%'}
            color="warning"
          />
        </CCol>
      </CRow>

      <CRow>
        <CCol md={8}>
          <CCard className="mb-4">
            <CCardHeader>Revenue Overview</CCardHeader>
            <CCardBody>
              <CChart type="line" data={revenueData} />
            </CCardBody>
          </CCard>
        </CCol>
        <CCol md={4}>
          <CCard className="mb-4">
            <CCardHeader>Subscription Distribution</CCardHeader>
            <CCardBody>
              <CChart type="doughnut" data={subscriptionData} />
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>

      <CRow>
        <CCol xs={12}>
          <CCard className="mb-4">
            <CCardHeader>
              <div className="d-flex justify-content-between align-items-center">
                <div>
                  <strong>Transaction History</strong>
                  <CBadge color="primary" className="ms-2">
                    {filteredTransactions.length} Transactions
                  </CBadge>
                </div>
                <div className="d-flex gap-2">
                  <CInputGroup style={{ width: '300px' }}>
                    <CFormInput
                      placeholder="Search transactions..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                    <CButton color="primary" variant="outline">
                      <CIcon icon={cilSearch} />
                    </CButton>
                  </CInputGroup>
                  <CDropdown autoClose="outside">
                    <CDropdownToggle color="secondary">
                      <CIcon icon={cilFilter} className="me-1" /> Filters
                    </CDropdownToggle>
                    <CDropdownMenu>
                      <CDropdownItem header>Status</CDropdownItem>
                      <CDropdownItem>
                        <CFormSelect
                          size="sm"
                          value={filters.status}
                          onChange={(e) => handleFilterChange('status', e.target.value)}
                        >
                          <option value="">All Status</option>
                          <option value="success">Success</option>
                          <option value="pending">Pending</option>
                          <option value="failed">Failed</option>
                        </CFormSelect>
                      </CDropdownItem>
                      <CDropdownItem>
                        <div className="d-flex gap-2">
                          <div>
                            <small>From</small>
                            <CFormInput
                              type="date"
                              size="sm"
                              value={filters.startDate}
                              onChange={(e) => handleFilterChange('startDate', e.target.value)}
                            />
                          </div>
                          <div>
                            <small>To</small>
                            <CFormInput
                              type="date"
                              size="sm"
                              value={filters.endDate}
                              onChange={(e) => handleFilterChange('endDate', e.target.value)}
                            />
                          </div>
                        </div>
                      </CDropdownItem>
                    </CDropdownMenu>
                  </CDropdown>
                </div>
              </div>
            </CCardHeader>
            <CCardBody>
              <CTable hover responsive>
                <CTableHead>
                  <CTableRow>
                    <CTableHeaderCell>Invoice ID</CTableHeaderCell>
                    <CTableHeaderCell>Email</CTableHeaderCell>
                    <CTableHeaderCell>Amount</CTableHeaderCell>
                    <CTableHeaderCell>Date & Time</CTableHeaderCell>
                    <CTableHeaderCell>Status</CTableHeaderCell>
                    <CTableHeaderCell>Actions</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {currentTransactions.map((transaction) => (
                    <CTableRow key={transaction.id}>
                      <CTableDataCell>{transaction.providerId}</CTableDataCell>
                      <CTableDataCell>{transaction.userId?.email}</CTableDataCell>

                      <CTableDataCell>{formatCurrency(transaction.amount)}</CTableDataCell>
                      <CTableDataCell>{formatDateTime(transaction.createdAt)}</CTableDataCell>
                      <CTableDataCell>
                        <CBadge
                          color={
                            transaction.status === 'success'
                              ? 'success'
                              : transaction.status === 'pending'
                                ? 'warning'
                                : 'danger'
                          }
                        >
                          {transaction.status}
                        </CBadge>
                      </CTableDataCell>
                      <CTableDataCell>
                        <CButton
                          color="primary"
                          size="sm"
                          className="me-2"
                          onClick={() => {
                            setSelectedTransaction(transaction)
                            setViewModal(true)
                          }}
                        >
                          Details
                        </CButton>
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
              {/* Pagination Controls */}
              <div>
                {Array.from(
                  { length: Math.ceil(filteredTransactions.length / transactionsPerPage) },
                  (_, i) => (
                    <CButton
                      className="me-1"
                      key={i}
                      onClick={() => handlePageChange(i + 1)}
                      color={currentPage === i + 1 ? 'primary' : 'secondary'} // Highlight current page
                    >
                      {i + 1}
                    </CButton>
                  ),
                )}
              </div>
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>

      {/* Transaction Details Modal */}
      <CModal visible={viewModal} onClose={() => setViewModal(false)} size="lg">
        <CModalHeader>
          <CModalTitle>Transaction Details</CModalTitle>
        </CModalHeader>
        <CModalBody>
          {selectedTransaction && (
            <div>
              <p>
                <strong>Invoice ID:</strong> {selectedTransaction.providerId}
              </p>

              <p>
                <strong>Email:</strong> {selectedTransaction?.userId?.email}
              </p>

              <p>
                <strong>Amount:</strong> {formatCurrency(selectedTransaction?.amount)}
              </p>
              <p>
                <strong>Date & Time:</strong> {formatDateTime(selectedTransaction?.createdAt)}
              </p>
              <p>
                <strong>Status:</strong> {selectedTransaction?.status}
              </p>
              {(transactionCheck?.status || transactionCheck?.message) && (
                <div>
                  <h5>Check Transaction</h5>
                  <p>
                    <strong>Message:</strong> {transactionCheck?.message}
                  </p>
                  <p>
                    <strong>Status:</strong> {transactionCheck?.status}
                  </p>
                </div>
              )}
            </div>
          )}
          {/* Pagination Controls */}
        </CModalBody>
        <CModalFooter>
          {!transactionCheck?.status ? (
            <CButton
              color="primary"
              onClick={() => handleCheckStatus(selectedTransaction?.providerId)}
            >
              Check
            </CButton>
          ) : transactionCheck?.status === selectedTransaction?.status ? (
            <CButton color="primary" disabled>
              Checked
            </CButton>
          ) : (
            <CButton
              color="primary"
              onClick={() => handleUpdateStatus(selectedTransaction?.providerId)}
            >
              Update Status
            </CButton>
          )}

          <CButton color="secondary" onClick={() => handleCloseModal()}>
            Close
          </CButton>
        </CModalFooter>
      </CModal>
    </>
  )
}
const ProtectedRevenue = () => {
  return (
    <ProtectRouter>
      <Revenue />
    </ProtectRouter>
  )
}
export default ProtectedRevenue

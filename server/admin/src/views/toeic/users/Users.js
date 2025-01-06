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
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilSearch, cilFilter, cilTrash, cilPencil, cilUser } from '@coreui/icons'
import { useNavigate } from 'react-router-dom' // Import useNavigate
import { endpoint } from '../../../api'
import instance from '../../../configs/axios.instance'
import { formatDate } from '../../../utils/formatDate'
import ProtectRouter from '../../../wrapper/ProtectRouter'

function isPremium(user) {
  if (user.upgradeExpiredDate === null) {
    return false
  }
  const today = new Date()
  const expiredDate = new Date(user.upgradeExpiredDate)
  return expiredDate > today
}
function formatUser(user) {
  return user.map((user) => {
    return {
      ...user,
      status: user.status === 'active' ? 'Active' : 'Blocked',
      membershipType: isPremium(user) ? 'Premium' : 'Regular',
      registeredDate: formatDate(user.createdAt),
    }
  })
}
const Users = () => {
  const navigate = useNavigate() // Initialize useNavigate

  const [users, setUsers] = useState([])

  const [filteredUsers, setFilteredUsers] = useState([])
  const [searchTerm, setSearchTerm] = useState('')
  const [filters, setFilters] = useState({
    status: '',
    membershipType: '',
    dateRange: '',
  })

  // Modal states
  const [deleteModal, setDeleteModal] = useState(false)
  const [selectedUser, setSelectedUser] = useState(null)

  // Search and Filter Logic
  useEffect(() => {
    let result = [...users]

    // Search
    if (searchTerm) {
      result = result.filter((user) => user.email.toLowerCase().includes(searchTerm.toLowerCase()))
    }

    // Status filter
    if (filters.status) {
      result = result.filter((user) => user.status === filters.status)
    }

    // Membership filter
    if (filters.membershipType) {
      result = result.filter((user) => user.membershipType === filters.membershipType)
    }

    // Date range filter
    if (filters.dateRange) {
      const today = new Date()
      const days = {
        last7days: 7,
        last30days: 30,
        last90days: 90,
      }
      const daysAgo = new Date(today.setDate(today.getDate() - days[filters.dateRange]))

      result = result.filter((user) => new Date(user.registeredDate) >= daysAgo)
    }

    setFilteredUsers(result)
  }, [users, searchTerm, filters])

  // Action Handlers
  const handleDelete = () => {
    setUsers((prev) => prev.filter((user) => user.id !== selectedUser.id))
    setDeleteModal(false)
  }

  const handleStatusChange = (user) => {
    const { id, status } = user
    console.log(id, status)
    setUsers((prev) =>
      prev.map((u) =>
        u.id === user.id ? { ...u, status: u.status === 'Active' ? 'Blocked' : 'Active' } : u,
      ),
    )
  }

  const handleFilterChange = (filterType, value) => {
    setFilters((prev) => ({
      ...prev,
      [filterType]: value,
    }))
  }

  // Pagination states
  const [currentPage, setCurrentPage] = useState(1)
  const usersPerPage = 5 // Number of users per page

  // Handle page change
  const handlePageChange = (pageNumber) => {
    setCurrentPage(pageNumber)
  }

  // Add more fake users
  const additionalUsers = [
    {
      id: 14,
      username: 'alicegreen',
      email: 'alice.green@example.com',
      status: 'Active',
      membershipType: 'Regular',
      lastLogin: '2024-03-21',
      registeredDate: '2024-01-05',
      examsTaken: 12,
    },
    {
      id: 15,
      username: 'bobwhite',
      email: 'bob.white@example.com',
      status: 'Blocked',
      membershipType: 'Premium',
      lastLogin: '2024-03-22',
      registeredDate: '2024-02-10',
      examsTaken: 5,
    },
    {
      id: 16,
      username: 'charlieblack',
      email: 'charlie.black@example.com',
      status: 'Active',
      membershipType: 'Regular',
      lastLogin: '2024-03-23',
      registeredDate: '2024-01-15',
      examsTaken: 8,
    },
    {
      id: 17,
      username: 'davidblue',
      email: 'david.blue@example.com',
      status: 'Inactive',
      membershipType: 'Premium',
      lastLogin: '2024-03-24',
      registeredDate: '2024-02-20',
      examsTaken: 10,
    },
    {
      id: 18,
      username: 'evewhite',
      email: 'eve.white@example.com',
      status: 'Active',
      membershipType: 'Regular',
      lastLogin: '2024-03-25',
      registeredDate: '2024-03-01',
      examsTaken: 6,
    },
    // ... add more users as needed ...
  ]

  useEffect(() => {
    async function fetchData() {
      const { data } = await instance.get(endpoint.user.get)
      setUsers(formatUser(data))
    }
    fetchData()
  }, [])

  // Calculate the current users to display
  const indexOfLastUser = currentPage * usersPerPage
  const indexOfFirstUser = indexOfLastUser - usersPerPage
  const currentUsers = filteredUsers.slice(indexOfFirstUser, indexOfLastUser)

  return (
    <>
      <CRow>
        <CCol xs={12}>
          <CCard className="mb-4">
            <CCardHeader>
              <div className="d-flex justify-content-between align-items-center">
                <div>
                  <strong>Users Management</strong>
                  <CBadge color="primary" className="ms-2">
                    {users.length} Users
                  </CBadge>
                </div>
                <div className="d-flex gap-2">
                  <CInputGroup style={{ width: '300px' }}>
                    <CFormInput
                      placeholder="Search users..."
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
                          <option value="Active">Active</option>
                          <option value="Blocked">Blocked</option>
                        </CFormSelect>
                      </CDropdownItem>
                      <CDropdownItem header>Membership</CDropdownItem>
                      <CDropdownItem>
                        <CFormSelect
                          size="sm"
                          value={filters.membershipType}
                          onChange={(e) => handleFilterChange('membershipType', e.target.value)}
                        >
                          <option value="">All Types</option>
                          <option value="Regular">Regular</option>
                          <option value="Premium">Premium</option>
                        </CFormSelect>
                      </CDropdownItem>
                      <CDropdownItem header>Registration Date</CDropdownItem>
                      <CDropdownItem>
                        <CFormSelect
                          size="sm"
                          value={filters.dateRange}
                          onChange={(e) => handleFilterChange('dateRange', e.target.value)}
                        >
                          <option value="">All Time</option>
                          <option value="last7days">Last 7 Days</option>
                          <option value="last30days">Last 30 Days</option>
                          <option value="last90days">Last 90 Days</option>
                        </CFormSelect>
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
                    <CTableHeaderCell>Email</CTableHeaderCell>
                    <CTableHeaderCell>Status</CTableHeaderCell>
                    <CTableHeaderCell>Membership</CTableHeaderCell>
                    <CTableHeaderCell>Registration Date</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {filteredUsers.length > 0 ? (
                    currentUsers.map((user) => (
                      <CTableRow key={user.id}>
                        <CTableDataCell>{user.email}</CTableDataCell>
                        <CTableDataCell>
                          <CBadge color={user.status === 'Active' ? 'success' : 'danger'}>
                            {user.status}
                          </CBadge>
                        </CTableDataCell>
                        <CTableDataCell>
                          <CBadge color={user.membershipType === 'Premium' ? 'warning' : 'info'}>
                            {user.membershipType}
                          </CBadge>
                        </CTableDataCell>
                        <CTableDataCell>{user.registeredDate}</CTableDataCell>
                        {/* <CTableDataCell>
                          <CButton
                            color={user.status === 'Active' ? 'danger' : 'success'}
                            size="sm"
                            className="me-2"
                            onClick={() => handleStatusChange(user)}
                          >
                            {user.status === 'Active' ? 'Block' : 'Unblock'}
                          </CButton>
                        </CTableDataCell> */}
                      </CTableRow>
                    ))
                  ) : (
                    <CTableRow>
                      <CTableDataCell colSpan="8" className="text-center">
                        No users available.
                      </CTableDataCell>
                    </CTableRow>
                  )}
                </CTableBody>
              </CTable>
              {/* Pagination Controls */}
              <div>
                {Array.from({ length: Math.ceil(filteredUsers.length / usersPerPage) }, (_, i) => (
                  <CButton
                    className="me-1"
                    key={i}
                    onClick={() => handlePageChange(i + 1)}
                    color={currentPage === i + 1 ? 'primary' : 'secondary'} // Highlight current page
                  >
                    {i + 1}
                  </CButton>
                ))}
              </div>
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>

      {/* Delete Confirmation Modal */}
      <CModal visible={deleteModal} onClose={() => setDeleteModal(false)}>
        <CModalHeader>
          <CModalTitle>Confirm Delete</CModalTitle>
        </CModalHeader>
        <CModalBody>
          Are you sure you want to delete user &quot;{selectedUser?.username}?&quot; This action
          cannot be undone.
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={() => setDeleteModal(false)}>
            Cancel
          </CButton>
          <CButton color="danger" onClick={handleDelete}>
            Delete
          </CButton>
        </CModalFooter>
      </CModal>
    </>
  )
}
const ProtectedUsers = () => {
  return (
    <ProtectRouter>
      <Users />
    </ProtectRouter>
  )
}
export default ProtectedUsers

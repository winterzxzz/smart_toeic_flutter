import React, { useEffect, useState } from 'react'
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
  CFormSelect,
  CInputGroup,
  CFormInput,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilFile, cilPencil, cilSearch, cilTrash } from '@coreui/icons'
import { useNavigate } from 'react-router-dom'
import instance from '../../../configs/axios.instance'
import { endpoint } from '../../../api'
import { offset } from '@popperjs/core'
import ProtectRouter from '../../../wrapper/ProtectRouter'
import { formatDate } from '../../../utils/formatDate'
import { toast } from 'react-toastify'

const ExamList = () => {
  const [exams, setExams] = useState([
    {
      id: 1,
      title: 'TOEIC Full Test 01',
      difficulty: 'Intermediate',
      attempts: 156,
      avgScore: 685,
      status: 'Published',
      postedTime: '2023-10-01 10:00 AM', // Example posted time
    },
    // Add more mock data
  ])
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState('')
  const [difficultyFilter, setDifficultyFilter] = useState('')
  const [typeFilter, setTypeFilter] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const examsPerPage = 4
  const navigate = useNavigate()
  const handlePageChange = (page) => {
    setCurrentPage(page)
  }

  const handleViewDetails = (examId) => {
    navigate(`/toeic/exams/details/${examId}`)
  }

  const handleEditInforExam = (examId) => {
    navigate(`/toeic/exams/edit/${examId}`)
  }
  const handleEditFileExam = (examId) => {
    navigate(`/toeic/exams/upload/${examId}`)
  }
  const handleDeleteExam = async (examId) => {
    if (window.confirm('Are you sure you want to delete this exam?')) {
      const { data } = await instance.delete(endpoint.test.delete(examId))
      setExams(exams.filter((exam) => exam.id !== examId))
      toast.success('Exam deleted successfully')
    } else {
      toast.error('Failed to delete exam')
    }
  }
  const handleViewTemplate = () => {
    const url =
      'https://docs.google.com/spreadsheets/d/1gzZJZ90qk1KIadXhqyct_CBksHfk-_hORWm27r9XX2U/edit?usp=sharing' // sau có thể lấy từ DB, biến,....
    window.open(url, '_blank') // Mở liên kết trong tab mới
  }
  const filteredExams = exams.filter((exam) => {
    const matchesSearch = exam.title.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesDifficulty = !difficultyFilter || exam.difficulty === difficultyFilter
    const matchesType = !typeFilter || exam.type === typeFilter
    const status = exam.isPublished ? 'Published' : 'Draft'
    const matchesStatus = !statusFilter || status === statusFilter
    return matchesSearch && matchesDifficulty && matchesType && matchesStatus
  })
  const startIndex = (currentPage - 1) * examsPerPage
  const endIndex = startIndex + examsPerPage
  const currentExams = filteredExams.slice(startIndex, endIndex)
  useEffect(() => {
    const fetchExams = async () => {
      const { data } = await instance.get(endpoint.test.get, {
        params: {
          offset: 0,
          limit: 10,
        },
      })
      console.log(data)
      setExams(data)
    }
    fetchExams()
  }, [])
  useEffect(() => {
    console.log('exams', exams)
  }, [exams])

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <div className="d-flex justify-content-between">
              <strong>Exam Management</strong>
              <div>
                <CButton
                  color="primary"
                  className="me-2"
                  onClick={() => navigate('/toeic/exams/create')}
                >
                  Create New Exam
                </CButton>
                <CButton
                  color="success"
                  style={{ color: 'white' }}
                  className="me-2"
                  onClick={handleViewTemplate}
                >
                  View Template
                </CButton>
              </div>
            </div>
          </CCardHeader>
          <CCardBody>
            <div className="mb-4 d-flex gap-3 flex-wrap">
              <CInputGroup style={{ maxWidth: '300px' }}>
                <CFormInput
                  placeholder="Search posts..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </CInputGroup>

              <CFormSelect
                style={{ maxWidth: '200px' }}
                value={difficultyFilter}
                onChange={(e) => setDifficultyFilter(e.target.value)}
              >
                <option value="">Difficulty</option>
                <option value="beginner">Beginner</option>
                <option value="intermediate">Intermediate</option>
                <option value="advanced">Advanced</option>
              </CFormSelect>
              <CFormSelect
                style={{ maxWidth: '200px' }}
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value)}
              >
                <option value="">Type</option>
                <option value="miniexam">Mini Exam</option>
                <option value="exam">Full Test</option>
              </CFormSelect>

              <CFormSelect
                style={{ maxWidth: '150px' }}
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">All Status</option>
                <option value="Published">Published</option>
                <option value="Draft">Draft</option>
              </CFormSelect>
            </div>
            <CTable hover responsive>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Title</CTableHeaderCell>
                  <CTableHeaderCell>Difficulty</CTableHeaderCell>
                  <CTableHeaderCell>Exam Attempts</CTableHeaderCell>
                  <CTableHeaderCell>Status</CTableHeaderCell>
                  <CTableHeaderCell>Type</CTableHeaderCell>
                  <CTableHeaderCell>Duration</CTableHeaderCell>
                  <CTableHeaderCell>Posted Time</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {currentExams.map((exam) => (
                  <CTableRow key={exam.id}>
                    <CTableDataCell>{exam.title}</CTableDataCell>
                    <CTableDataCell>{exam.difficulty}</CTableDataCell>
                    <CTableDataCell>{exam.attemptCount}</CTableDataCell>
                    <CTableDataCell>
                      <CBadge color={exam.isPublished ? 'success' : 'warning'}>
                        {exam.isPublished ? 'Published' : 'Draft'}
                      </CBadge>
                    </CTableDataCell>
                    <CTableDataCell>{exam.type}</CTableDataCell>
                    <CTableDataCell>{exam.duration}</CTableDataCell>
                    <CTableDataCell>{formatDate(exam.createdAt)}</CTableDataCell>
                    <CTableDataCell>
                      <div className="d-flex gap-2">
                        <CButton
                          color="primary"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleEditInforExam(exam.id)}
                        >
                          <CIcon icon={cilPencil} />
                        </CButton>
                        {/* <CButton
                          color="primary"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleEditFileExam(exam.id)}
                        >
                          <CIcon icon={cilFile} />
                        </CButton> */}
                        <CButton
                          color="danger"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleDeleteExam(exam.id)}
                        >
                          <CIcon color="primary" icon={cilTrash} />
                        </CButton>
                      </div>
                    </CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
            <div>
              {Array.from({ length: Math.ceil(filteredExams.length / examsPerPage) }, (_, i) => (
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
  )
}
const ProtectedExamList = () => {
  return (
    <ProtectRouter>
      <ExamList />
    </ProtectRouter>
  )
}
export default ProtectedExamList

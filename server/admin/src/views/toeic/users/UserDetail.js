import React, { useState, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import {
  CCard,
  CCardBody,
  CCardHeader,
  CFormSelect,
  CFormInput,
  CTable,
  CTableBody,
  CTableHeaderCell,
  CTableRow,
  CTableDataCell,
  CRow,
  CCol,
  CButton,
} from '@coreui/react'

const UserDetail = () => {
  const { userId } = useParams()
  const [user, setUser] = useState(null)
  const [examHistory, setExamHistory] = useState([])
  const [scoreOrder, setScoreOrder] = useState('')
  const [dateOrder, setDateOrder] = useState('')
  const [searchTerm, setSearchTerm] = useState('')

  // Pagination states
  const [currentPage, setCurrentPage] = useState(1)
  const examsPerPage = 5 // Number of exams per page

  useEffect(() => {
    // Dữ liệu người dùng giả
    const fetchedUser = {
      id: userId,
      username: 'johndoe',
      email: 'john@example.com',
      status: 'Active',
      membership: 'Premium',
      registrationDate: '2023-12-15',
      lastLogin: '2024-03-20',
      examsTaken: 15,
      examHistory: [
        { examId: 1, title: 'Toeic 1', attempts: [
            { totalCorrect: 45, date: '2024-03-01T10:00:00', listeningCorrect: 20, readingCorrect: 25 },
            { totalCorrect: 40, date: '2024-03-10T10:00:00', listeningCorrect: 18, readingCorrect: 22 }
          ] 
        },
        { examId: 2, title: 'Toeic 2', attempts: [
            { totalCorrect: 50, date: '2024-03-05T10:00:00', listeningCorrect: 25, readingCorrect: 25 }
          ] 
        },
        { examId: 3, title: 'Toeic 3', attempts: [
            { totalCorrect: 50, date: '2024-03-15T11:30:00', listeningCorrect: 22, readingCorrect: 28 }
          ] 
        },
        { examId: 4, title: 'Toeic 4', attempts: [
            { totalCorrect: 55, date: '2024-03-20T11:30:00', listeningCorrect: 30, readingCorrect: 25 }
          ] 
        },
        { examId: 5, title: 'Toeic 5', attempts: [
            { totalCorrect: 48, date: '2024-03-25T10:00:00', listeningCorrect: 24, readingCorrect: 24 }
          ] 
        },
        { examId: 6, title: 'Toeic 6', attempts: [
            { totalCorrect: 52, date: '2024-03-30T10:00:00', listeningCorrect: 26, readingCorrect: 26 }
          ] 
        },
        { examId: 7, title: 'Toeic 7', attempts: [
            { totalCorrect: 40, date: '2024-04-01T10:00:00', listeningCorrect: 20, readingCorrect: 20 }
          ] 
        },
        { examId: 8, title: 'Toeic 8', attempts: [
            { totalCorrect: 60, date: '2024-04-05T10:00:00', listeningCorrect: 30, readingCorrect: 30 }
          ] 
        },
      ],
    }
    setUser(fetchedUser)
    setExamHistory(fetchedUser.examHistory)
  }, [userId])

  // Filter + Sort: Chỉ làm việc trên mảng mới
  const getFilteredAndSortedExams = () => {
    let filteredExams = [...examHistory] // Tạo bản sao để tránh thay đổi trực tiếp
    if (searchTerm) {
      filteredExams = filteredExams.filter((exam) =>
        exam.title.toLowerCase().includes(searchTerm.toLowerCase())
      )
    }

    // Flatten attempts for sorting
    const flattenedExams = filteredExams.flatMap(exam => 
      exam.attempts.map(attempt => ({
        examId: exam.examId,
        title: exam.title,
        ...attempt
      }))
    );

    if (scoreOrder) {
      flattenedExams.sort((a, b) =>
        scoreOrder === 'asc' ? a.totalCorrect - b.totalCorrect : b.totalCorrect - a.totalCorrect
      )
    } else if (dateOrder) {
      flattenedExams.sort((a, b) =>
        dateOrder === 'asc'
          ? new Date(a.date) - new Date(b.date)
          : new Date(b.date) - new Date(a.date)
      )
    }
    return flattenedExams
  }

  const sortedExamHistory = getFilteredAndSortedExams()

  // Calculate the current exams to display
  const indexOfLastExam = currentPage * examsPerPage
  const indexOfFirstExam = indexOfLastExam - examsPerPage
  const currentExams = sortedExamHistory.slice(indexOfFirstExam, indexOfLastExam)

  // Handle page change
  const handlePageChange = (pageNumber) => {
    setCurrentPage(pageNumber)
  }

  return (
    <CCard>
      <CCardHeader>
        <h5>User Details: {user?.username}</h5>
      </CCardHeader>
      <CCardBody>
        <p>
          <strong>Email:</strong> {user?.email}<br />
          <strong>Status:</strong> {user?.status}<br />
          <strong>Membership:</strong> {user?.membership}<br />
          <strong>Registration Date:</strong> {user?.registrationDate}<br />
          <strong>Last Login:</strong> {user?.lastLogin}<br />
          <strong>Exams Taken:</strong> {user?.examsTaken}
        </p>
        <CRow className="mb-3">
          <CCol md={4}>
            <CFormSelect
              onChange={(e) => setScoreOrder(e.target.value)}
              value={scoreOrder}
              aria-label="Sort by total correct answers"
            >
              <option value="">Sort by Score</option>
              <option value="asc">Score Ascending</option>
              <option value="desc">Score Descending</option>
            </CFormSelect>
          </CCol>
          <CCol md={4}>
            <CFormSelect
              onChange={(e) => setDateOrder(e.target.value)}
              value={dateOrder}
              aria-label="Sort by date"
            >
              <option value="">Sort by Date</option>
              <option value="asc">Date Ascending</option>
              <option value="desc">Date Descending</option>
            </CFormSelect>
          </CCol>
          <CCol md={4}>
            <CFormInput
              type="text"
              placeholder="Search by exam title"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              aria-label="Search by exam title"
            />
          </CCol>
        </CRow>
        <CTable hover responsive>
          <thead>
            <CTableRow>
              <CTableHeaderCell>Exam ID</CTableHeaderCell>
              <CTableHeaderCell>Title</CTableHeaderCell>
              <CTableHeaderCell>Total Correct</CTableHeaderCell>
              <CTableHeaderCell>Date</CTableHeaderCell>
              <CTableHeaderCell>Listening Correct</CTableHeaderCell>
              <CTableHeaderCell>Reading Correct</CTableHeaderCell>
            </CTableRow>
          </thead>
          <CTableBody>
            {currentExams.length > 0 ? (
              currentExams.map((exam) => (
                <CTableRow key={`${exam.examId}-${exam.date}`}>
                  <CTableDataCell>{exam.examId}</CTableDataCell>
                  <CTableDataCell>{exam.title}</CTableDataCell>
                  <CTableDataCell>{exam.totalCorrect}</CTableDataCell>
                  <CTableDataCell>{new Date(exam.date).toLocaleString()}</CTableDataCell>
                  <CTableDataCell>{exam.listeningCorrect}</CTableDataCell>
                  <CTableDataCell>{exam.readingCorrect}</CTableDataCell>
                </CTableRow>
              ))
            ) : (
              <CTableRow>
                <CTableDataCell colSpan="6" className="text-center">No exam history available.</CTableDataCell>
              </CTableRow>
            )}
          </CTableBody>
        </CTable>
        {/* Pagination Controls */}
        <div>
          {Array.from({ length: Math.ceil(sortedExamHistory.length / examsPerPage) }, (_, i) => (
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
  )
}

export default UserDetail

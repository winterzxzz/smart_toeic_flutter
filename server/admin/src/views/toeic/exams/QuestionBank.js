import React, { useState } from 'react'
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
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CForm,
  CFormLabel,
  CFormTextarea,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilPlus, cilCloudDownload, cilCloudUpload } from '@coreui/icons'
import { TOEIC_PARTS } from '../../../constants/toeicParts'
import ProtectRouter from '../../../wrapper/ProtectRouter'

const QuestionBank = () => {
  const [showAddModal, setShowAddModal] = useState(false)
  const [selectedPart, setSelectedPart] = useState('')
  const [questions] = useState([
    {
      id: 1,
      part: 1,
      type: 'Photographs',
      questionText: 'What is shown in the image?',
      difficulty: 'Medium',
      lastUsed: '2024-03-15',
      usageCount: 25,
      hasAudio: true,
      hasImage: true,
    },
    {
      id: 2,
      part: 2,
      type: 'Question-Response',
      questionText: 'When does the meeting start?',
      difficulty: 'Easy',
      lastUsed: '2024-03-18',
      usageCount: 15,
      hasAudio: true,
      hasImage: false,
    },
    // Add more mock questions
  ])

  const [newQuestion, setNewQuestion] = useState({
    part: '',
    questionText: '',
    answers: {
      A: '',
      B: '',
      C: '',
      D: '',
    },
    correctAnswer: '',
    difficulty: 'Medium',
  })

  const handleAddQuestion = (e) => {
    e.preventDefault()
    console.log('New question:', newQuestion)
    setShowAddModal(false)
    // Add API call here
  }

  return (
    <>
      <CRow>
        <CCol xs={12}>
          <CCard className="mb-4">
            <CCardHeader>
              <div className="d-flex justify-content-between align-items-center">
                <strong>Question Bank</strong>
                <div className="d-flex gap-2">
                  <CButton color="success" className="d-flex align-items-center gap-2">
                    <CIcon icon={cilCloudUpload} /> Import Questions
                  </CButton>
                  <CButton color="primary" className="d-flex align-items-center gap-2">
                    <CIcon icon={cilCloudDownload} /> Export Questions
                  </CButton>
                  <CButton
                    color="primary"
                    className="d-flex align-items-center gap-2"
                    onClick={() => setShowAddModal(true)}
                  >
                    <CIcon icon={cilPlus} /> Add Question
                  </CButton>
                </div>
              </div>
            </CCardHeader>
            <CCardBody>
              <div className="mb-4 d-flex gap-3">
                <CFormSelect
                  style={{ width: '200px' }}
                  value={selectedPart}
                  onChange={(e) => setSelectedPart(e.target.value)}
                >
                  <option value="">All Parts</option>
                  {Object.entries(TOEIC_PARTS).map(([num, part]) => (
                    <option key={num} value={num}>
                      Part {num}: {part.name}
                    </option>
                  ))}
                </CFormSelect>
                <CFormSelect style={{ width: '150px' }}>
                  <option value="">All Difficulties</option>
                  <option value="Easy">Easy</option>
                  <option value="Medium">Medium</option>
                  <option value="Hard">Hard</option>
                </CFormSelect>
                <CInputGroup style={{ width: '300px' }}>
                  <CFormInput placeholder="Search questions..." />
                  <CButton color="primary" variant="outline">
                    Search
                  </CButton>
                </CInputGroup>
              </div>

              <CTable hover responsive>
                <CTableHead>
                  <CTableRow>
                    <CTableHeaderCell>Part</CTableHeaderCell>
                    <CTableHeaderCell>Question</CTableHeaderCell>
                    <CTableHeaderCell>Difficulty</CTableHeaderCell>
                    <CTableHeaderCell>Last Used</CTableHeaderCell>
                    <CTableHeaderCell>Usage Count</CTableHeaderCell>
                    <CTableHeaderCell>Media</CTableHeaderCell>
                    <CTableHeaderCell>Actions</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {questions.map((question) => (
                    <CTableRow key={question.id}>
                      <CTableDataCell>
                        <CBadge color="info">Part {question.part}</CBadge>
                      </CTableDataCell>
                      <CTableDataCell>{question.questionText}</CTableDataCell>
                      <CTableDataCell>
                        <CBadge
                          color={
                            question.difficulty === 'Easy'
                              ? 'success'
                              : question.difficulty === 'Medium'
                                ? 'warning'
                                : 'danger'
                          }
                        >
                          {question.difficulty}
                        </CBadge>
                      </CTableDataCell>
                      <CTableDataCell>{question.lastUsed}</CTableDataCell>
                      <CTableDataCell>{question.usageCount}</CTableDataCell>
                      <CTableDataCell>
                        {question.hasAudio && (
                          <CBadge color="success" className="me-1">
                            Audio
                          </CBadge>
                        )}
                        {question.hasImage && <CBadge color="info">Image</CBadge>}
                      </CTableDataCell>
                      <CTableDataCell>
                        <CButton color="info" size="sm" className="me-2">
                          Edit
                        </CButton>
                        <CButton color="danger" size="sm">
                          Delete
                        </CButton>
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>

      {/* Add Question Modal */}
      <CModal visible={showAddModal} onClose={() => setShowAddModal(false)}>
        <CModalHeader>
          <CModalTitle>Add New Question</CModalTitle>
        </CModalHeader>
        <CModalBody>
          <CForm onSubmit={handleAddQuestion}>
            <div className="mb-3">
              <CFormLabel>TOEIC Part</CFormLabel>
              <CFormSelect
                value={newQuestion.part}
                onChange={(e) => setNewQuestion({ ...newQuestion, part: e.target.value })}
                required
              >
                <option value="">Select Part</option>
                {Object.entries(TOEIC_PARTS).map(([num, part]) => (
                  <option key={num} value={num}>
                    Part {num}: {part.name}
                  </option>
                ))}
              </CFormSelect>
            </div>

            <div className="mb-3">
              <CFormLabel>Question Text</CFormLabel>
              <CFormTextarea
                value={newQuestion.questionText}
                onChange={(e) => setNewQuestion({ ...newQuestion, questionText: e.target.value })}
                rows={3}
                required
              />
            </div>

            <div className="mb-3">
              <CFormLabel>Answer Options</CFormLabel>
              {['A', 'B', 'C', 'D'].map((option) => (
                <CFormInput
                  key={option}
                  className="mb-2"
                  placeholder={`Answer ${option}`}
                  value={newQuestion.answers[option]}
                  onChange={(e) =>
                    setNewQuestion({
                      ...newQuestion,
                      answers: {
                        ...newQuestion.answers,
                        [option]: e.target.value,
                      },
                    })
                  }
                  required
                />
              ))}
            </div>

            <div className="mb-3">
              <CFormLabel>Correct Answer</CFormLabel>
              <CFormSelect
                value={newQuestion.correctAnswer}
                onChange={(e) => setNewQuestion({ ...newQuestion, correctAnswer: e.target.value })}
                required
              >
                <option value="">Select Correct Answer</option>
                {['A', 'B', 'C', 'D'].map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </CFormSelect>
            </div>

            <div className="mb-3">
              <CFormLabel>Difficulty</CFormLabel>
              <CFormSelect
                value={newQuestion.difficulty}
                onChange={(e) => setNewQuestion({ ...newQuestion, difficulty: e.target.value })}
                required
              >
                <option value="Easy">Easy</option>
                <option value="Medium">Medium</option>
                <option value="Hard">Hard</option>
              </CFormSelect>
            </div>

            <CModalFooter>
              <CButton color="secondary" onClick={() => setShowAddModal(false)}>
                Cancel
              </CButton>
              <CButton color="primary" type="submit">
                Add Question
              </CButton>
            </CModalFooter>
          </CForm>
        </CModalBody>
      </CModal>
    </>
  )
}
const ProtectedQuestionBank = () => {
  return (
    <ProtectRouter>
      <QuestionBank />
    </ProtectRouter>
  )
}
export default ProtectedQuestionBank

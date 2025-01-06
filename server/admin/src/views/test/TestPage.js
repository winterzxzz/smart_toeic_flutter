import React, { useState, useRef, useEffect } from 'react'
import {
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
  CForm,
  CFormInput,
  CFormSelect,
  CFormLabel,
  CButton,
  CTable,
  CTableBody,
  CTableDataCell,
  CTableHead,
  CTableHeaderCell,
  CTableRow,
  CToaster,
  CToast,
  CToastBody,
  CToastHeader,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilCloudDownload } from '@coreui/icons'
import * as XLSX from 'xlsx'
// import { uploadFile } from '../../services/firebase/storage'

// Define TOEIC parts structure
const TOEIC_PARTS = {
  1: {
    name: 'Photographs',
    type: 'listening',
    requirements: ['audio', 'image'],
    description:
      'Four short statements about a photograph. Select the one that best describes the photograph.',
  },
  2: {
    name: 'Question-Response',
    type: 'listening',
    requirements: ['audio'],
    description: 'Three responses to one question. Select the best response.',
  },
  3: {
    name: 'Conversations',
    type: 'listening',
    requirements: ['audio', 'optional-image'],
    description: 'Listen to conversations and answer three questions for each.',
  },
  4: {
    name: 'Talks',
    type: 'listening',
    requirements: ['audio', 'optional-image'],
    description: 'Listen to talks and answer three questions for each.',
  },
}

const initialFormState = {
  part: '',
  questionText: '',
  audioFile: null,
  audioPreview: null,
  imageFile: null,
  imagePreview: null,
  correctAnswer: '',
}

const TestPage = () => {
  const [activeTab, setActiveTab] = useState(1)
  const [formData, setFormData] = useState(initialFormState)
  const [questions, setQuestions] = useState([])
  const [toast, addToast] = useState(0)
  const [editingId, setEditingId] = useState(null)
  const toaster = useRef()

  useEffect(() => {
    const fetchQuestions = async () => {
      try {
        const response = await fetch('/api/questions')
        if (!response.ok) {
          throw new Error('Failed to fetch questions')
        }
        const data = await response.json()
        setQuestions(data)
      } catch (error) {
        addToast(
          <CToast>
            <CToastHeader closeButton>
              <strong className="me-auto text-danger">Error</strong>
            </CToastHeader>
            <CToastBody>Failed to load questions</CToastBody>
          </CToast>,
        )
      }
    }

    fetchQuestions()
  }, [])

  const handleImageChange = (e) => {
    const file = e.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onloadend = () => {
        setFormData((prev) => ({
          ...prev,
          imageFile: file,
          imagePreview: reader.result,
        }))
      }
      reader.readAsDataURL(file)
    }
  }

  const handleAnswerChange = (option, value) => {
    setFormData((prev) => ({
      ...prev,
      answers: {
        ...prev.answers,
        [option]: value,
      },
    }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    try {
      let imageUrl = null
      let audioUrl = null
      let imageStoragePath = null
      let audioStoragePath = null

      // Upload audio file if exists
      if (formData.audioFile) {
        const audioUpload = await uploadFile(formData.audioFile, 'audio')
        audioUrl = audioUpload.url
        audioStoragePath = audioUpload.path
      }

      // Upload image file if exists and if it's part 1
      if (formData.imageFile && formData.part === '1') {
        const imageUpload = await uploadFile(formData.imageFile, 'images')
        imageUrl = imageUpload.url
        imageStoragePath = imageUpload.path
      }

      const newQuestion = {
        id: editingId || Date.now(),
        ...formData,
        imageUrl,
        audioUrl,
        imageStoragePath,
        audioStoragePath,
      }

      // Here you would typically save to MongoDB instead of localStorage
      // Example API call:
      const response = await fetch('/api/questions', {
        method: editingId ? 'PUT' : 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newQuestion),
      })

      if (!response.ok) {
        throw new Error('Failed to save question')
      }

      // Update local state
      let newQuestions
      if (editingId) {
        newQuestions = questions.map((q) => (q.id === editingId ? newQuestion : q))
        setEditingId(null)
      } else {
        newQuestions = [...questions, newQuestion]
      }

      setQuestions(newQuestions)
      setFormData(initialFormState)

      addToast(
        <CToast>
          <CToastHeader closeButton>
            <strong className="me-auto">Success</strong>
          </CToastHeader>
          <CToastBody>
            {editingId ? 'Question updated successfully!' : 'Question added successfully!'}
          </CToastBody>
        </CToast>,
      )
    } catch (error) {
      addToast(
        <CToast>
          <CToastHeader closeButton>
            <strong className="me-auto text-danger">Error</strong>
          </CToastHeader>
          <CToastBody>{error.message || 'An error occurred!'}</CToastBody>
        </CToast>,
      )
    }
  }

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this question?')) {
      try {
        const question = questions.find((q) => q.id === id)
        if (question.audioStoragePath) {
          await deleteFile(question.audioStoragePath)
        }
        if (question.imageStoragePath) {
          await deleteFile(question.imageStoragePath)
        }

        // Delete from MongoDB
        const response = await fetch(`/api/questions/${id}`, {
          method: 'DELETE',
        })

        if (!response.ok) {
          throw new Error('Failed to delete question')
        }

        // Update local state
        const newQuestions = questions.filter((q) => q.id !== id)
        setQuestions(newQuestions)

        addToast(
          <CToast>
            <CToastHeader closeButton>
              <strong className="me-auto">Success</strong>
            </CToastHeader>
            <CToastBody>Question deleted successfully!</CToastBody>
          </CToast>,
        )
      } catch (error) {
        addToast(
          <CToast>
            <CToastHeader closeButton>
              <strong className="me-auto text-danger">Error</strong>
            </CToastHeader>
            <CToastBody>{error.message || 'Failed to delete question'}</CToastBody>
          </CToast>,
        )
      }
    }
  }

  const handleEdit = (question) => {
    setFormData({
      ...question,
      imagePreview: question.imageUrl,
    })
    setEditingId(question.id)
    setActiveTab(1)
  }

  const handleExportTemplate = () => {
    const wb = generateExcelTemplate()
    XLSX.writeFile(wb, 'toeic_questions_template.xlsx')
  }

  const handleExportQuestions = () => {
    exportToExcel(questions)
  }

  const handleImportExcel = async (e) => {
    const file = e.target.files[0]
    if (file) {
      try {
        const importedQuestions = await importFromExcel(file)
        setQuestions((prev) => [...prev, ...importedQuestions])
        localStorage.setItem('toeicQuestions', JSON.stringify([...questions, ...importedQuestions]))

        addToast(
          <CToast>
            <CToastHeader closeButton>
              <strong className="me-auto">Success</strong>
            </CToastHeader>
            <CToastBody>{`Successfully imported ${importedQuestions.length} questions!`}</CToastBody>
          </CToast>,
        )
      } catch (error) {
        addToast(
          <CToast>
            <CToastHeader closeButton>
              <strong className="me-auto text-danger">Error</strong>
            </CToastHeader>
            <CToastBody>{error.message}</CToastBody>
          </CToast>,
        )
      }
    }
  }

  const handleAudioChange = (e) => {
    const file = e.target.files[0]
    if (file) {
      const audioUrl = URL.createObjectURL(file)
      setFormData((prev) => ({
        ...prev,
        audioFile: file,
        audioPreview: audioUrl,
      }))
    }
  }

  useEffect(() => {
    return () => {
      // Cleanup URLs when component unmounts
      if (formData.audioPreview) {
        URL.revokeObjectURL(formData.audioPreview)
      }
      if (formData.imagePreview) {
        URL.revokeObjectURL(formData.imagePreview)
      }
    }
  }, [])

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>TOEIC Question Management</strong>
          </CCardHeader>
          <CCardBody>
            <CNav variant="tabs">
              <CNavItem>
                <CNavLink active={activeTab === 1} onClick={() => setActiveTab(1)}>
                  Add Question
                </CNavLink>
              </CNavItem>
              <CNavItem>
                <CNavLink active={activeTab === 2} onClick={() => setActiveTab(2)}>
                  Import Excel
                </CNavLink>
              </CNavItem>
              <CNavItem>
                <CNavLink active={activeTab === 3} onClick={() => setActiveTab(3)}>
                  Question List
                </CNavLink>
              </CNavItem>
            </CNav>

            <CTabContent>
              {/* Add Question Tab */}
              <CTabPane visible={activeTab === 1}>
                <CForm onSubmit={handleSubmit} className="mt-3">
                  <CRow>
                    <CCol md={12}>
                      <CFormLabel>Part</CFormLabel>
                      <CFormSelect
                        value={formData.part}
                        onChange={(e) => setFormData({ ...formData, part: e.target.value })}
                        className="mb-3"
                        required
                      >
                        <option value="">Select part...</option>
                        {Object.entries(TOEIC_PARTS).map(([key, value]) => (
                          <option key={key} value={key}>
                            Part {key}: {value.name}
                          </option>
                        ))}
                      </CFormSelect>
                    </CCol>

                    {formData.part && (
                      <>
                        <CCol md={12}>
                          {formData.part === '1' ? (
                            <div className="mb-3">
                              <small className="text-medium-emphasis">
                                {TOEIC_PARTS[formData.part].description}
                              </small>
                            </div>
                          ) : (
                            <>
                              <CFormLabel>Question Text</CFormLabel>
                              <CFormInput
                                type="text"
                                value={formData.questionText}
                                onChange={(e) =>
                                  setFormData({ ...formData, questionText: e.target.value })
                                }
                                className="mb-3"
                                required
                              />
                            </>
                          )}
                        </CCol>

                        <CCol md={12}>
                          <CFormLabel>Audio File</CFormLabel>
                          <CFormInput
                            type="file"
                            accept="audio/*"
                            onChange={handleAudioChange}
                            className="mb-3"
                            required={!editingId}
                          />
                          {formData.audioPreview && (
                            <div className="mb-3">
                              <audio controls>
                                <source src={formData.audioPreview} type="audio/mpeg" />
                                Your browser does not support the audio element.
                              </audio>
                            </div>
                          )}
                        </CCol>

                        {formData.part === '1' && (
                          <CCol md={12}>
                            <CFormLabel>Image</CFormLabel>
                            <CFormInput
                              type="file"
                              accept="image/*"
                              onChange={handleImageChange}
                              className="mb-3"
                              required={!editingId}
                            />
                            {formData.imagePreview && (
                              <div className="mb-3">
                                <img
                                  src={formData.imagePreview}
                                  alt="Preview"
                                  style={{
                                    maxWidth: '400px',
                                    maxHeight: '300px',
                                    objectFit: 'contain',
                                  }}
                                />
                              </div>
                            )}
                          </CCol>
                        )}

                        {formData.part !== '1' && (
                          <>
                            {['A', 'B', 'C', 'D'].map((option) => (
                              <CCol md={6} key={option}>
                                <CFormLabel>Answer {option}</CFormLabel>
                                <CFormInput
                                  type="text"
                                  value={formData.answers[option]}
                                  onChange={(e) => handleAnswerChange(option, e.target.value)}
                                  className="mb-3"
                                  required
                                />
                              </CCol>
                            ))}
                          </>
                        )}

                        <CCol md={6}>
                          <CFormLabel>Correct Answer</CFormLabel>
                          <CFormSelect
                            value={formData.correctAnswer}
                            onChange={(e) =>
                              setFormData({ ...formData, correctAnswer: e.target.value })
                            }
                            className="mb-3"
                            required
                          >
                            <option value="">Select correct answer...</option>
                            {['A', 'B', 'C', 'D'].map((option) => (
                              <option key={option} value={option}>
                                {option}
                              </option>
                            ))}
                          </CFormSelect>
                        </CCol>

                        <CCol xs={12}>
                          <CButton type="submit" color="primary">
                            {editingId ? 'Update Question' : 'Add Question'}
                          </CButton>
                          {editingId && (
                            <CButton
                              type="button"
                              color="secondary"
                              className="ms-2"
                              onClick={() => {
                                setEditingId(null)
                                setFormData(initialFormState)
                              }}
                            >
                              Cancel Edit
                            </CButton>
                          )}
                        </CCol>
                      </>
                    )}
                  </CRow>
                </CForm>
              </CTabPane>

              {/* Question List Tab */}
              <CTabPane visible={activeTab === 3}>
                <CTable hover responsive className="mt-3">
                  <CTableHead>
                    <CTableRow>
                      <CTableHeaderCell scope="col">#</CTableHeaderCell>
                      <CTableHeaderCell scope="col">Part</CTableHeaderCell>
                      <CTableHeaderCell scope="col">Question</CTableHeaderCell>
                      <CTableHeaderCell scope="col">Correct Answer</CTableHeaderCell>
                      <CTableHeaderCell scope="col">Actions</CTableHeaderCell>
                    </CTableRow>
                  </CTableHead>
                  <CTableBody>
                    {questions.map((question, index) => (
                      <CTableRow key={question.id}>
                        <CTableHeaderCell scope="row">{index + 1}</CTableHeaderCell>
                        <CTableDataCell>Part {question.part}</CTableDataCell>
                        <CTableDataCell>{question.questionText}</CTableDataCell>
                        <CTableDataCell>{question.correctAnswer}</CTableDataCell>
                        <CTableDataCell>
                          <CButton
                            color="primary"
                            size="sm"
                            className="me-2"
                            onClick={() => handleEdit(question)}
                          >
                            Edit
                          </CButton>
                          <CButton
                            color="danger"
                            size="sm"
                            onClick={() => handleDelete(question.id)}
                          >
                            Delete
                          </CButton>
                        </CTableDataCell>
                      </CTableRow>
                    ))}
                  </CTableBody>
                </CTable>
              </CTabPane>

              {/* Import Excel Tab */}
              <CTabPane visible={activeTab === 2}>
                <div className="mt-3">
                  <CButton color="primary" onClick={handleExportTemplate} className="me-2">
                    <CIcon icon={cilCloudDownload} className="me-2" />
                    Download Template
                  </CButton>

                  <CButton color="success" onClick={handleExportQuestions}>
                    Export Questions
                  </CButton>

                  <div className="mt-3">
                    <CFormLabel>Import Excel File</CFormLabel>
                    <CFormInput type="file" accept=".xlsx,.xls" onChange={handleImportExcel} />
                  </div>
                </div>
              </CTabPane>
            </CTabContent>

            <CToaster ref={toaster} push={toast} placement="top-end" />
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default TestPage

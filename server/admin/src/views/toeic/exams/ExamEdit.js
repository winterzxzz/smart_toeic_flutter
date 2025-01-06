import React, { useState, useEffect } from 'react'
import {
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
  CForm,
  CFormInput,
  CFormLabel,
  CFormSelect,
  CButton,
  CAlert,
} from '@coreui/react'
import { useParams, useNavigate } from 'react-router-dom'
import ProtectRouter from '../../../wrapper/ProtectRouter'

const ExamEdit = () => {
  const { examId } = useParams()
  const navigate = useNavigate()
  const [examData, setExamData] = useState({
    title: '',
    difficulty: 'intermediate',
    status: 'Draft',
  })
  const [fileSelected, setFileSelected] = useState(false)
  const [fileValid, setFileValid] = useState(null)

  useEffect(() => {
    // Fetch the exam data by examId and set it to examData
    // Example: setExamData(fetchedExamData)
  }, [examId])

  const handleInputChange = (e) => {
    const { name, value } = e.target
    setExamData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  const handleFileUpload = (event) => {
    const file = event.target.files[0]
    if (file) {
      setFileSelected(true)
      console.log('File selected:', file.name)
    }
  }

  const handleFileValidation = () => {
    console.log('Validate uploaded file')
    // Add validation logic here
    setFileValid(true) // or false based on validation
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    console.log('Form submitted:', examData)
    // Add API call to update the exam
    navigate('/toeic/exams/list')
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Edit Exam</strong>
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleSubmit}>
              <CRow className="mb-3">
                <CCol md={6}>
                  <CFormLabel htmlFor="examTitle">Exam Title</CFormLabel>
                  <CFormInput
                    id="examTitle"
                    name="title"
                    value={examData.title}
                    onChange={handleInputChange}
                    placeholder="Enter exam title"
                    required
                  />
                </CCol>
                <CCol md={3}>
                  <CFormLabel htmlFor="difficulty">Difficulty Level</CFormLabel>
                  <CFormSelect
                    id="difficulty"
                    name="difficulty"
                    value={examData.difficulty}
                    onChange={handleInputChange}
                  >
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                  </CFormSelect>
                </CCol>
                <CCol md={3}>
                  <CFormLabel htmlFor="status">Status</CFormLabel>
                  <CFormSelect
                    id="status"
                    name="status"
                    value={examData.status}
                    onChange={handleInputChange}
                  >
                    <option value="Draft">Draft</option>
                    <option value="Published">Published</option>
                  </CFormSelect>
                </CCol>
              </CRow>
              <CRow className="mb-3">
                <CCol md={12}>
                  <CFormLabel htmlFor="uploadExcel">Upload Excel</CFormLabel>
                  <input
                    type="file"
                    accept=".xlsx"
                    onChange={handleFileUpload}
                    style={{ display: 'block' }}
                    id="upload-excel"
                  />
                  {fileSelected && (
                    <div className="d-flex gap-2 mt-2">
                      <CButton color="info" onClick={handleFileValidation}>
                        Check File
                      </CButton>
                      {fileValid !== null && (
                        <CAlert color={fileValid ? 'success' : 'danger'} className="mt-2">
                          {fileValid ? 'File is valid!' : 'File is invalid!'}
                        </CAlert>
                      )}
                    </div>
                  )}
                </CCol>
              </CRow>
              <CButton type="submit" color="primary" disabled={!fileValid}>
                Save Changes
              </CButton>
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}
const ProtectedExamEdit = () => {
  return (
    <ProtectRouter>
      <ExamEdit />
    </ProtectRouter>
  )
}
export default ProtectedExamEdit

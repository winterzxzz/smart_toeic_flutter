import React, { useState } from 'react'
import { CButton, CCard, CCardBody, CCardHeader, CCol, CRow } from '@coreui/react'
import ProtectRouter from '../../../wrapper/ProtectRouter'

const ExamUpload = () => {
  const [fileData, setFileData] = useState(null)

  const handleFileValidation = () => {
    console.log('Validate uploaded file')
    // Add validation logic here
  }

  const handleSubmit = () => {
    console.log('Submit file data:', fileData)
    // Add submit logic here
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Upload TOEIC Exam</strong>
          </CCardHeader>
          <CCardBody>
            <CButton color="info" onClick={handleFileValidation}>
              Check File
            </CButton>
            <CButton color="success" onClick={handleSubmit} className="ms-2">
              Submit
            </CButton>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}
const ProtectedExamUpload = () => {
  return (
    <ProtectRouter>
      <ExamUpload />
    </ProtectRouter>
  )
}
export default ProtectedExamUpload

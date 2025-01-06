import React, { useState } from 'react'
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
  CFormFeedback,
} from '@coreui/react'
import axios from 'axios'
import { useEffect } from 'react'
import * as XLSX from 'xlsx'
import { toast } from 'react-toastify'
import { endpoint } from '../../../api'
import instance from '../../../configs/axios.instance'
import ProtectRouter from '../../../wrapper/ProtectRouter'
const ExamCreate = () => {
  const [examData, setExamData] = useState({
    title: '',
    type: '',
    numberOfQuestions: 0,
    difficulty: 'intermediate',
    parts: [],
  })
  const [fileSelected, setFileSelected] = useState(false)
  const [fileValid, setFileValid] = useState(null)
  const [touched, setTouched] = useState({
    title: false,
    difficulty: false,
    status: false,
    numberOfQuestions: false,
  })
  const [errors, setErrors] = useState({})
  const [files, setFiles] = useState({
    images: null,
    audioFiles: null,
    excelFile: null,
  })
  const [type, setType] = useState('')
  const [parts, setParts] = useState([])
  const [numberOfQuestions, setNumberOfQuestions] = useState(0)
  const [previewImages, setPreviewImages] = useState([])
  const [previewAudio, setPreviewAudio] = useState([])
  const [isValid, setIsValid] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState(null)
  const [uploadError, setUploadError] = useState(null)
  const [excelData, setExcelData] = useState([])
  const [errorCells, setErrorCells] = useState([])
  const [validationMessage, setValidationMessage] = useState('')
  const [isPublished, setIsPublished] = useState(false)
  const [duration, setDuration] = useState(0)
  const validateForm = () => {
    const newErrors = {}

    // Validate title
    if (!examData.title.trim()) {
      newErrors.title = 'Title is required'
    }

    // Validate difficulty
    if (!examData.difficulty) {
      newErrors.difficulty = 'Difficulty is required'
    }

    // Validate file
    if (!fileSelected || fileValid !== true) {
      newErrors.file = 'A valid file is required'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }
  const handleIsPublishedChange = (e) => {
    setIsPublished(e.target.value)
  }
  const handleNumberOfQuestionsChange = (e) => {
    setNumberOfQuestions(e.target.value)
  }
  const handleInputChange = (e) => {
    const { name, value } = e.target
    setExamData((prev) => ({
      ...prev,
      [name]: value,
    }))

    // Tắt lỗi khi trường đã có lỗi được nhập dữ liệu
    if (errors[name]) {
      setErrors((prev) => ({
        ...prev,
        [name]: null,
      }))
    }
  }

  const handleBlur = (field) => {
    setTouched((prev) => ({
      ...prev,
      [field]: true,
    }))
  }

  const handleDurationChange = (e) => {
    setDuration(e.target.value)
  }

  const handleFileUpload = async (event) => {
    const file = event.target.files[0]
    if (!file) return

    setIsLoading(true)
    setError(null)
    setUploadError(null)
    setExcelData([])

    try {
      const arrayBuffer = await file.arrayBuffer()
      const workbook = XLSX.read(arrayBuffer)
      const worksheet = workbook.Sheets[workbook.SheetNames[0]]
      const jsonData = XLSX.utils
        .sheet_to_json(worksheet, { header: 1, defval: '' })
        .filter((row) => {
          return !row.every((cell) => !cell)
        })
      console.log(jsonData)
      setNumberOfQuestions(jsonData.length - 1)
      const partSet = new Set(jsonData.map((row) => row[10]))
      setParts(Array.from(partSet).filter((part) => typeof part === 'number'))

      // Validate headers for all test types
      const headers = jsonData[0]
      const requiredHeaders = [
        'number',
        'image',
        'audio',
        'paragraph',
        'question',
        'option1',
        'option2',
        'option3',
        'option4',
        'correctanswer',
        'part',
        'category',
        'transcript',
      ]
      const isValidHeader = requiredHeaders.every((header) => headers.includes(header))

      if (!isValidHeader) {
        setUploadError('Tiêu đề không hợp lệ trong file tải lên. Vui lòng đảm bảo tiêu đề đúng.')
        return
      }

      // Validate data for all test types
      const newErrorCells = []
      const isValidData = jsonData.slice(1).every((row, rowIndex) => {
        const isValidRow = row[0] && row[5] && row[6] && row[7] && row[9] // Check required fields
        if (!isValidRow) {
          // Highlight specific cells that are missing required fields
          if (!row[0]) newErrorCells.push({ row: rowIndex + 2, col: 0 }) // "number"
          if (!row[5]) newErrorCells.push({ row: rowIndex + 2, col: 5 }) // "option1"
          if (!row[6]) newErrorCells.push({ row: rowIndex + 2, col: 6 }) // "option2"
          if (!row[7]) newErrorCells.push({ row: rowIndex + 2, col: 7 }) // "option3"
          if (!row[9]) newErrorCells.push({ row: rowIndex + 2, col: 9 }) // "correctanswer"
        }
        return isValidRow
      })

      setErrorCells(newErrorCells) // Update state with error cells
      setExcelData(jsonData) // Store the valid Excel data for preview

      // Kiểm tra tính hợp lệ của dữ liệu
      const allErrors = errorCells.length === 0 && newErrorCells.length === 0
      setIsValid(isValidHeader && isValidData && allErrors)
      setValidationMessage(
        allErrors ? 'File Excel hợp lệ!' : 'Có lỗi trong file Excel. Vui lòng kiểm tra lại.',
      )

      if (!isValidData) {
        return // If any row is invalid, stop further processing
      }

      setFiles((prev) => ({ ...prev, excelFile: [file] }))
    } catch (err) {
      setUploadError('Lỗi khi phân tích file Excel. Vui lòng đảm bảo đó là file .xlsx hợp lệ.')
    } finally {
      setIsLoading(false)
    }
  }

  const handleFileValidation = () => {
    console.log('Validate uploaded file')
    // Add validation logic here
    setFileValid(true) // or false based on validation
  }

  const handleChange = (e) => {
    const { name, files: selectedFiles } = e.target
    setFiles({
      ...files,
      [name]: selectedFiles,
    })

    // Tạo preview cho ảnh
    if (name === 'images') {
      const imageFiles = Array.from(selectedFiles)
      setPreviewImages(imageFiles.map((file) => URL.createObjectURL(file)))
    }

    // Tạo preview cho audio
    if (name === 'audioFiles') {
      const audioFiles = Array.from(selectedFiles)
      setPreviewAudio(audioFiles.map((file) => URL.createObjectURL(file)))
    }

    // Tạo preview cho file Excel
    if (name === 'excelFile') {
      const excelFile = selectedFiles[0]
      if (excelFile) {
        console.log('Excel file selected:', excelFile.name)
        handleFileUpload(e) // Call the upload handler to process the file
      }
    }
  }

  const handleTypeChange = (e) => {
    setType(e.target.value)
  }

  const handleValidate = () => {
    // Xóa lỗi trước khi xác thực
    setErrors({})
    setValidationMessage('')

    // Kiểm tra các trường bắt buộc
    const newErrors = {}
    if (!examData.title.trim()) {
      newErrors.title = 'Exam Title là bắt buộc'
    }
    if (!examData.difficulty) {
      newErrors.difficulty = 'Difficulty Level là bắt buộc'
    }
    if (!duration) {
      newErrors.duration = 'Duration là bắt buộc'
    }
    if (duration <= 0) {
      newErrors.duration = 'Duration phải lớn hơn 0'
    }
    if (isNaN(Number(duration))) {
      newErrors.duration = 'Duration phải là số'
    }
    if (!type) {
      newErrors.type = 'Test Type là bắt buộc'
    }
    if (!numberOfQuestions) {
      newErrors.numberOfQuestions = 'Number of Questions là bắt buộc'
    }
    if (numberOfQuestions <= 0) {
      newErrors.numberOfQuestions = 'Number of Questions phải lớn hơn 0'
    }

    // Kiểm tra file Excel
    const validExcel =
      files.excelFile && files.excelFile.length > 0 && errorCells.length === 0 && !uploadError

    // Cập nhật lỗi nếu có
    setErrors(newErrors)

    // Nếu có lỗi, hiển thị thông báo
    if (Object.keys(newErrors).length > 0 || !validExcel) {
      setIsValid(false)
      toast.error(Object.values(newErrors)[0])
      return
    }

    // Nếu tất cả đều hợp lệ
    setIsValid(true)
    toast.success('Validation successful!')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!isValid) {
      setValidationMessage('Please check the Excel file and other fields before saving.')
      return
    }

    // Prepare form data for submission
    const formData = new FormData()
    if (files.images) {
      for (let i = 0; i < files.images.length; i++) {
        formData.append('images', files.images[i])
      }
    }
    if (files.audioFiles) {
      for (let i = 0; i < files.audioFiles.length; i++) {
        formData.append('audioFiles', files.audioFiles[i])
      }
    }
    if (files.excelFile) {
      formData.append('excelFile', files.excelFile[0])
    }
    formData.append('type', type)
    formData.append('title', examData.title)
    formData.append('numberOfQuestions', numberOfQuestions)
    formData.append('parts', JSON.stringify(parts))
    formData.append('difficulty', examData.difficulty)
    formData.append('duration', duration)
    formData.append('isPublished', isPublished)
    // Log the submitted data
    console.log('Submitted Data:', {
      title: examData.title,
      difficulty: examData.difficulty,
      type: type,
      numberOfQuestions: numberOfQuestions,
      parts: parts,
      files: {
        images: files.images ? Array.from(files.images).map((file) => file.name) : [],
        audioFiles: files.audioFiles ? Array.from(files.audioFiles).map((file) => file.name) : [],
        excelFile: files.excelFile ? files.excelFile[0].name : null,
      },
    })

    try {
      const response = await instance.post(endpoint.test.create, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      console.log('Exam created successfully:', response.data)
      setValidationMessage('Bài kiểm tra đã được lưu thành công!')
      toast.success('Bài kiểm tra đã được lưu thành công!')
      resetForm() // Reset the form after successful submission
    } catch (error) {
      console.error('Error creating exam:', error)
      toast.error('Có lỗi xảy ra khi lưu bài kiểm tra.')
      setValidationMessage('Có lỗi xảy ra khi lưu bài kiểm tra.')
    }
  }

  const resetForm = () => {
    setExamData({ title: '', difficulty: 'intermediate', numberOfQuestions: 0, parts: [] })
    setFiles({ images: null, audioFiles: null, excelFile: null })
    setType('')
    setPreviewImages([])
    setPreviewAudio([])
    setIsValid(false) // Reset trạng thái nút submit
    setErrors({}) // Reset lỗi
    setValidationMessage('') // Reset thông báo
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Create New Exam</strong>
          </CCardHeader>
          <CCardBody>
            {uploadError && (
              <CAlert color="danger" onClose={() => setUploadError(null)} dismissible>
                {uploadError}
              </CAlert>
            )}
            {validationMessage && (
              <CAlert color={isValid ? 'success' : 'danger'} dismissible>
                {validationMessage}
              </CAlert>
            )}
            <CForm onSubmit={handleSubmit}>
              <CRow className="mb-3">
                <CCol md={6}>
                  <CFormLabel htmlFor="examTitle">Exam Title</CFormLabel>
                  <CFormInput
                    id="examTitle"
                    name="title"
                    value={examData.title}
                    onChange={handleInputChange}
                    onBlur={() => handleBlur('title')}
                    placeholder="Enter exam title"
                    invalid={touched.title && errors.title}
                  />
                  {touched.title && errors.title && (
                    <CFormFeedback invalid>{errors.title}</CFormFeedback>
                  )}
                </CCol>
                <CCol md={6}>
                  <CFormLabel htmlFor="difficulty">Difficulty Level</CFormLabel>
                  <CFormSelect
                    id="difficulty"
                    Test
                    Type
                    name="difficulty"
                    value={examData.difficulty}
                    onChange={handleInputChange}
                    onBlur={() => handleBlur('difficulty')}
                    invalid={touched.difficulty && errors.difficulty}
                  >
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                  </CFormSelect>
                  {touched.difficulty && errors.difficulty && (
                    <CFormFeedback invalid>{errors.difficulty}</CFormFeedback>
                  )}
                </CCol>
              </CRow>
              <CRow className="mb-3">
                <CCol md={6}>
                  <CFormLabel htmlFor="testType">Test Type</CFormLabel>
                  <CFormSelect id="testType" name="type" value={type} onChange={handleTypeChange}>
                    <option value="" disabled>
                      Select a test type
                    </option>
                    <option value="exam">Exam</option>
                    <option value="miniexam">Mini Exam</option>
                  </CFormSelect>
                </CCol>
                <CCol md={6}>
                  <CFormLabel htmlFor="testType">Duration (minutes)</CFormLabel>
                  <CFormInput
                    id="duration"
                    name="duration"
                    value={duration}
                    onChange={handleDurationChange}
                  />
                </CCol>
              </CRow>

              <CRow className="mb-3">
                <CCol className="mb-1" md={12}>
                  <label className="me-1" htmlFor="">
                    Image
                  </label>
                  <input
                    type="file"
                    name="images"
                    multiple
                    webkitdirectory="true"
                    onChange={handleChange}
                    accept="image/*"
                  />
                  {previewImages.length > 0 && (
                    <div>
                      <h5>Preview Images:</h5>
                      {previewImages.map((src, index) => (
                        <img
                          key={index}
                          src={src}
                          alt={`preview ${index}`}
                          style={{ width: '100px', margin: '5px' }}
                        />
                      ))}
                    </div>
                  )}
                </CCol>
                <CCol className="mb-1" md={12}>
                  <label className="me-1" htmlFor="">
                    Audio
                  </label>
                  <input
                    type="file"
                    name="audioFiles"
                    multiple
                    onChange={handleChange}
                    webkitdirectory="true"
                    accept="audio/*"
                  />
                  {previewAudio.length > 0 && (
                    <div>
                      <h5>Preview Audio:</h5>
                      {previewAudio.map((src, index) => (
                        <audio key={index} controls>
                          <source src={src} type="audio/mpeg" />
                          Your browser does not support the audio tag.
                        </audio>
                      ))}
                    </div>
                  )}
                </CCol>
                <CCol className="mb-1" md={12}>
                  <label className="me-2" htmlFor="">
                    Excel
                  </label>
                  <input type="file" name="excelFile" onChange={handleChange} accept=".xls,.xlsx" />
                  {files.excelFile && files.excelFile.length > 0 && (
                    <div>
                      <h5>Uploaded Excel File:</h5>
                      <p>{files.excelFile[0].name}</p>
                      <div>
                        <div style={{ marginBottom: '10px' }}>
                          Number of Questions : {numberOfQuestions}
                        </div>
                        <div style={{ marginBottom: '10px' }}>Parts: {parts.join(', ')}</div>
                      </div>
                    </div>
                  )}
                </CCol>
              </CRow>
              <CRow>
                <CCol md={6}>
                  <CFormLabel htmlFor="isPublished">Publish</CFormLabel>
                  <CFormSelect
                    id="isPublished"
                    name="isPublished"
                    value={isPublished}
                    onChange={handleIsPublishedChange}
                  >
                    <option value="true">True</option>
                    <option value="false">False</option>
                  </CFormSelect>
                </CCol>
              </CRow>
              <div style={{ marginTop: '10px' }}>
                <CButton className="me-1" type="button" color="secondary" onClick={handleValidate}>
                  Check
                </CButton>
                <CButton type="submit" color="primary" disabled={!isValid}>
                  Save Exam
                </CButton>
              </div>
            </CForm>

            {/* Excel Preview Section */}
            {excelData.length > 0 && (
              <div style={{ marginTop: '20px' }}>
                <h5>Preview File Excel:</h5>
                {errorCells.length > 0 && (
                  <div style={{ color: 'red', marginTop: '10px', overflow: 'auto' }}>
                    <h6>Detected Errors:</h6>
                    <ul>
                      {errorCells.map((error, index) => (
                        <li key={index}>
                          Error at row {error.row}, column {error.col + 1}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
                <div style={{ overflow: 'auto', width: '100%' }}>
                  <table
                    style={{
                      borderCollapse: 'collapse',
                      border: '1px solid #ccc',
                    }}
                  >
                    <thead>
                      <tr>
                        {excelData[0].map((header, index) => (
                          <th
                            key={index}
                            style={{
                              border: '1px solid black',
                              padding: '8px',
                              backgroundColor: '#f2f2f2',
                            }}
                          >
                            {header}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody>
                      {excelData.slice(1).map((row, rowIndex) => (
                        <tr key={rowIndex}>
                          {row.map((cell, cellIndex) => {
                            // Kiểm tra xem ô hiện tại có lỗi không
                            const hasError = errorCells.some(
                              (error) => error.row === rowIndex + 2 && error.col === cellIndex,
                            )
                            return (
                              <td
                                key={cellIndex}
                                style={{
                                  border: '1px solid black',
                                  padding: '8px',
                                  backgroundColor: hasError ? '#ffcccc' : 'transparent', // Đánh dấu ô nếu có lỗi
                                  color: hasError ? 'red' : 'black', // Thay đổi màu chữ nếu có lỗi
                                }}
                              >
                                {cell}
                              </td>
                            )
                          })}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}
const ProtectedExamCreate = () => {
  return (
    <ProtectRouter>
      <ExamCreate />
    </ProtectRouter>
  )
}
export default ProtectedExamCreate

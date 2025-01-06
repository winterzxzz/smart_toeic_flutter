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
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CForm,
  CFormInput,
  CFormLabel,
  CAlert,
} from '@coreui/react'
import { useParams } from 'react-router-dom'
import CIcon from '@coreui/icons-react'
import { cilPencil, cilTrash } from '@coreui/icons'

const FlashCards = () => {
  const { id } = useParams()
  const [flashcards, setFlashcards] = useState([
    {
      id: 1,
      word: 'escape',
      pronunciation: '/ɪˈskeɪp/',
      translation: 'bỏ trốn, trốn thoát',
      definition: 'to get away from a place or dangerous situation',
      exampleSentences: [
        'The robber escaped from the prison.',
        "Unfortunately, I can't escape from the wolves' chase.",
      ],
      note: 'Commonly used to describe leaving or fleeing from a dangerous or unwanted situation.',
    },
    {
      id: 2,
      word: 'run',
      pronunciation: '/rʌn/',
      translation: 'chạy',
      definition: 'to move swiftly on foot',
      exampleSentences: ['She runs every morning.', 'The dog ran after the ball.'],
      note: 'Often used to describe fast movement.',
    },
  ])

  const [showModal, setShowModal] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [currentCard, setCurrentCard] = useState(null)
  const [newCard, setNewCard] = useState({
    word: '',
    pronunciation: '',
    translation: '',
    definition: '',
    exampleSentences: [],
    note: '',
  })

  const handleCreateCard = () => {
    if (editMode) {
      setFlashcards(flashcards.map((card) => (card.id === currentCard.id ? newCard : card)))
    } else {
      setFlashcards([...flashcards, { ...newCard, id: Date.now() }])
    }
    setShowModal(false)
    setEditMode(false)
    setNewCard({
      word: '',
      pronunciation: '',
      translation: '',
      definition: '',
      exampleSentences: [],
      note: '',
    })
  }

  const handleEditCard = (card) => {
    setEditMode(true)
    setCurrentCard(card)
    setNewCard(card)
    setShowModal(true)
  }

  const handleDeleteCard = (id) => {
    if (window.confirm('Are you sure you want to delete this flashcard?')) {
      setFlashcards(flashcards.filter((card) => card.id !== id))
    }
  }

  const [fileSelected, setFileSelected] = useState(false)
  const [fileValid, setFileValid] = useState(null)
  const [previewModalVisible, setPreviewModalVisible] = useState(false)
  const [previewData, setPreviewData] = useState([])
  const [errorMessages, setErrorMessages] = useState([])

  const handleFileUpload = (event) => {
    const file = event.target.files[0]
    if (file) {
      setFileSelected(true)
      console.log('File selected:', file.name)

      const fakeData = [
        {
          word: 'example',
          pronunciation: '/ɪɡˈzæmpəl/',
          translation: 'ví dụ',
          definition: 'a representative form or pattern',
          exampleSentences: ['This is an example sentence.'],
          note: 'Used to illustrate a point.',
        },
        {
          word: '',
          pronunciation: '/tɛst/',
          translation: 'kiểm tra',
          definition: 'a procedure intended to establish the quality, performance, or reliability of something',
          exampleSentences: ['I have a test tomorrow.'],
          note: 'Commonly used in educational contexts.',
        },
      ]

      const errors = []
      fakeData.forEach((item, index) => {
        if (!item.word) {
          errors.push(`Row ${index + 1}: Word is required.`)
        }
      })

      setPreviewData(fakeData)
      setErrorMessages(errors)
      setPreviewModalVisible(true)
    }
  }

  const handleFileValidation = () => {
    console.log('Validate uploaded file')
    // Add validation logic here
    const isValid = true; // Giả sử file hợp lệ
    setFileValid(isValid) // or false based on validation
    if (isValid) {
      setPreviewModalVisible(true) // Hiển thị modal preview nếu file hợp lệ
    }
  }

  const [touched, setTouched] = useState({
    title: false,
    difficulty: false,
    status: false,
  })

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Flashcards for Set {id}</strong>

            <input
              type="file"
              accept=".xlsx"
              onChange={handleFileUpload}
              style={{ display: 'block' }}
              id="upload-excel"
              className='mt-2'
            />
            <CButton color="success" className="mt-2" onClick={() => setShowModal(true)}>
              Create New Card
            </CButton>
          </CCardHeader>
          <CCardBody>
            <CTable hover responsive>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Word</CTableHeaderCell>
                  <CTableHeaderCell>Pronunciation</CTableHeaderCell>
                  <CTableHeaderCell>Translation</CTableHeaderCell>
                  <CTableHeaderCell>Definition</CTableHeaderCell>
                  <CTableHeaderCell>Example Sentences</CTableHeaderCell>
                  <CTableHeaderCell>Note</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {flashcards.map((card) => (
                  <CTableRow key={card.id}>
                    <CTableDataCell>{card.word}</CTableDataCell>
                    <CTableDataCell>{card.pronunciation}</CTableDataCell>
                    <CTableDataCell>{card.translation}</CTableDataCell>
                    <CTableDataCell>{card.definition}</CTableDataCell>
                    <CTableDataCell>
                      <ul>
                        {card.exampleSentences.map((sentence, index) => (
                          <li key={index}>{sentence}</li>
                        ))}
                      </ul>
                    </CTableDataCell>
                    <CTableDataCell>{card.note}</CTableDataCell>
                    <CTableDataCell>
                      <CButton
                        color="warning"
                        variant="outline"
                        size="sm"
                        className="me-2 d-flex align-items-center gap-2 mb-2"
                        onClick={() => handleEditCard(card)}
                      >
                        <CIcon icon={cilPencil} />
                      </CButton>
                      <CButton
                        color="danger"
                        variant="outline"
                        size="sm"
                        className="d-flex align-items-center gap-2"
                        onClick={() => handleDeleteCard(card.id)}
                      >
                        <CIcon icon={cilTrash} />
                      </CButton>
                    </CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
          </CCardBody>
        </CCard>
      </CCol>

      <CModal visible={showModal} onClose={() => setShowModal(false)}>
        <CModalHeader>
          <CModalTitle>{editMode ? 'Edit Flashcard' : 'Create New Flashcard'}</CModalTitle>
        </CModalHeader>
        <CModalBody>
          <CForm>
            <CFormInput
              label="Word"
              value={newCard.word}
              onChange={(e) => setNewCard({ ...newCard, word: e.target.value })}
            />
            <CFormInput
              label="Pronunciation"
              value={newCard.pronunciation}
              onChange={(e) => setNewCard({ ...newCard, pronunciation: e.target.value })}
            />
            <CFormInput
              label="Translation"
              value={newCard.translation}
              onChange={(e) => setNewCard({ ...newCard, translation: e.target.value })}
            />
            <CFormInput
              label="Definition"
              value={newCard.definition}
              onChange={(e) => setNewCard({ ...newCard, definition: e.target.value })}
            />
            <CFormInput
              label="Example Sentences (comma separated)"
              value={newCard.exampleSentences.join(', ')}
              onChange={(e) =>
                setNewCard({ ...newCard, exampleSentences: e.target.value.split(', ') })
              }
            />
            <CFormInput
              label="Note"
              value={newCard.note}
              onChange={(e) => setNewCard({ ...newCard, note: e.target.value })}
            />
          </CForm>
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </CButton>
          <CButton color="primary" onClick={handleCreateCard}>
            {editMode ? 'Save Changes' : 'Create'}
          </CButton>
        </CModalFooter>
      </CModal>

      <CModal visible={previewModalVisible} onClose={() => setPreviewModalVisible(false)} size="lg">
        <CModalHeader>
          <CModalTitle>Preview File</CModalTitle>
        </CModalHeader>
        <CModalBody>
          {errorMessages.length > 0 ? (
            <div>
              <p className="text-danger">Errors found:</p>
              <ul>
                {errorMessages.map((error, index) => (
                  <li key={index}>{error}</li>
                ))}
              </ul>
            </div>
          ) : (
            <CTable hover responsive>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Word</CTableHeaderCell>
                  <CTableHeaderCell>Pronunciation</CTableHeaderCell>
                  <CTableHeaderCell>Translation</CTableHeaderCell>
                  <CTableHeaderCell>Definition</CTableHeaderCell>
                  <CTableHeaderCell>Example Sentences</CTableHeaderCell>
                  <CTableHeaderCell>Note</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {previewData.map((item, index) => (
                  <CTableRow key={index}>
                    <CTableDataCell>{item.word}</CTableDataCell>
                    <CTableDataCell>{item.pronunciation}</CTableDataCell>
                    <CTableDataCell>{item.translation}</CTableDataCell>
                    <CTableDataCell>{item.definition}</CTableDataCell>
                    <CTableDataCell>
                      <ul>
                        {item.exampleSentences.map((sentence, idx) => (
                          <li key={idx}>{sentence}</li>
                        ))}
                      </ul>
                    </CTableDataCell>
                    <CTableDataCell>{item.note}</CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
          )}
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={() => setPreviewModalVisible(false)}>
            Close
          </CButton>
          {errorMessages.length === 0 && (
            <CButton color="primary" onClick={() => console.log('Submit file')}>
              Submit
            </CButton>
          )}
        </CModalFooter>
      </CModal>
    </CRow>
  )
}

export default FlashCards

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
} from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import CIcon from '@coreui/icons-react'
import { cilPencil, cilTrash, cilSearch } from '@coreui/icons'

const FlashCardSets = () => {
  const navigate = useNavigate()
  const [flashcardSets, setFlashcardSets] = useState([
    {
      id: 1,
      title: 'Basic Vocabulary',
      description: 'A set of basic vocabulary flashcards.',
      cardsCount: 50,
    },
    {
      id: 2,
      title: 'Advanced Grammar',
      description: 'Flashcards for advanced grammar rules.',
      cardsCount: 30,
    },
    {
      id: 3,
      title: 'Common Phrases',
      description: 'Flashcards for common English phrases.',
      cardsCount: 40,
    },
    {
      id: 4,
      title: 'Business English',
      description: 'Flashcards for business English terms.',
      cardsCount: 25,
    },
  ])

  const [showModal, setShowModal] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [currentSet, setCurrentSet] = useState(null)
  const [newSet, setNewSet] = useState({ title: '', description: '' })

  const handleCreateSet = () => {
    if (editMode) {
      setFlashcardSets(flashcardSets.map(set => set.id === currentSet.id ? newSet : set))
    } else {
      setFlashcardSets([...flashcardSets, { ...newSet, id: Date.now(), cardsCount: 0 }])
    }
    setShowModal(false)
    setEditMode(false)
    setNewSet({ title: '', description: '' })
  }

  const handleEditSet = (set) => {
    setEditMode(true)
    setCurrentSet(set)
    setNewSet(set)
    setShowModal(true)
  }

  const handleDeleteSet = (id) => {
    if (window.confirm('Are you sure you want to delete this flashcard set?')) {
      setFlashcardSets(flashcardSets.filter(set => set.id !== id))
    }
  }

  const handleViewSet = (id) => {
    navigate(`/toeic/flashcards/${id}`)
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Flashcard Sets</strong>
            <CButton color="primary" className="float-end" onClick={() => setShowModal(true)}>
              Create New Set
            </CButton>
          </CCardHeader>
          <CCardBody>
            <CTable hover responsive>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Title</CTableHeaderCell>
                  <CTableHeaderCell>Description</CTableHeaderCell>
                  <CTableHeaderCell>Number of Cards</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {flashcardSets.map((set) => (
                  <CTableRow key={set.id}>
                    <CTableDataCell>{set.title}</CTableDataCell>
                    <CTableDataCell>{set.description}</CTableDataCell>
                    <CTableDataCell>{set.cardsCount}</CTableDataCell>
                    <CTableDataCell style={{ display: 'flex', justifyContent: 'flex-start', gap: '0.5rem' }}>
                      <CButton color="info" variant="outline" size="sm" className="d-flex align-items-center gap-2" onClick={() => handleViewSet(set.id)}>
                        <CIcon icon={cilSearch} /> 
                      </CButton>
                      <CButton color="warning" variant="outline" size="sm" className="d-flex align-items-center gap-2" onClick={() => handleEditSet(set)}>
                        <CIcon icon={cilPencil} /> 
                      </CButton>
                      <CButton color="danger" variant="outline" size="sm" className="d-flex align-items-center gap-2" onClick={() => handleDeleteSet(set.id)}>
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
          <CModalTitle>{editMode ? 'Edit Flashcard Set' : 'Create New Flashcard Set'}</CModalTitle>
        </CModalHeader>
        <CModalBody>
          <CForm>
            <CFormInput
              label="Title"
              value={newSet.title}
              onChange={(e) => setNewSet({ ...newSet, title: e.target.value })}
            />
            <CFormInput
              label="Description"
              value={newSet.description}
              onChange={(e) => setNewSet({ ...newSet, description: e.target.value })}
            />
          </CForm>
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={() => setShowModal(false)}>Cancel</CButton>
          <CButton color="primary" onClick={handleCreateSet}>{editMode ? 'Save Changes' : 'Create'}</CButton>
        </CModalFooter>
      </CModal>
    </CRow>
  )
}

export default FlashCardSets

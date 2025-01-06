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
  CForm,
  CFormInput,
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilPencil, cilTrash } from '@coreui/icons'
import ProtectRouter from '../../../wrapper/ProtectRouter'

const Categories = () => {
  const [categories, setCategories] = useState([
    { id: 1, name: 'Study Tips', slug: 'study-tips', postCount: 5 },
    { id: 2, name: 'Listening', slug: 'listening', postCount: 3 },
    { id: 3, name: 'Reading', slug: 'reading', postCount: 4 },
  ])

  const [showModal, setShowModal] = useState(false)
  const [editingCategory, setEditingCategory] = useState(null)
  const [categoryName, setCategoryName] = useState('')

  const handleSubmit = (e) => {
    e.preventDefault()
    if (editingCategory) {
      // Update existing category
      setCategories(
        categories.map((cat) =>
          cat.id === editingCategory.id
            ? { ...cat, name: categoryName, slug: categoryName.toLowerCase().replace(/ /g, '-') }
            : cat,
        ),
      )
    } else {
      // Add new category
      setCategories([
        ...categories,
        {
          id: categories.length + 1,
          name: categoryName,
          slug: categoryName.toLowerCase().replace(/ /g, '-'),
          postCount: 0,
        },
      ])
    }
    handleCloseModal()
  }

  const handleCloseModal = () => {
    setShowModal(false)
    setEditingCategory(null)
    setCategoryName('')
  }

  const handleEdit = (category) => {
    setEditingCategory(category)
    setCategoryName(category.name)
    setShowModal(true)
  }

  const handleDelete = (categoryId) => {
    if (window.confirm('Are you sure you want to delete this category?')) {
      setCategories(categories.filter((cat) => cat.id !== categoryId))
    }
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <div className="d-flex justify-content-between align-items-center">
              <strong>Categories</strong>
              <CButton color="primary" onClick={() => setShowModal(true)}>
                Add Category
              </CButton>
            </div>
          </CCardHeader>
          <CCardBody>
            <CTable hover responsive>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Name</CTableHeaderCell>
                  <CTableHeaderCell>Slug</CTableHeaderCell>
                  <CTableHeaderCell>Posts</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {categories.map((category) => (
                  <CTableRow key={category.id}>
                    <CTableDataCell>{category.name}</CTableDataCell>
                    <CTableDataCell>{category.slug}</CTableDataCell>
                    <CTableDataCell>{category.postCount}</CTableDataCell>
                    <CTableDataCell>
                      <div className="d-flex gap-2">
                        <CButton
                          color="info"
                          variant="outline"
                          size="sm"
                          onClick={() => handleEdit(category)}
                        >
                          <CIcon icon={cilPencil} />
                        </CButton>
                        <CButton
                          color="danger"
                          variant="outline"
                          size="sm"
                          onClick={() => handleDelete(category.id)}
                        >
                          <CIcon icon={cilTrash} />
                        </CButton>
                      </div>
                    </CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
          </CCardBody>
        </CCard>
      </CCol>

      <CModal visible={showModal} onClose={handleCloseModal}>
        <CModalHeader>
          <CModalTitle>{editingCategory ? 'Edit Category' : 'Add Category'}</CModalTitle>
        </CModalHeader>
        <CForm onSubmit={handleSubmit}>
          <CModalBody>
            <CFormInput
              type="text"
              label="Category Name"
              value={categoryName}
              onChange={(e) => setCategoryName(e.target.value)}
              required
            />
          </CModalBody>
          <CModalFooter>
            <CButton color="secondary" onClick={handleCloseModal}>
              Cancel
            </CButton>
            <CButton color="primary" type="submit">
              {editingCategory ? 'Update' : 'Add'}
            </CButton>
          </CModalFooter>
        </CForm>
      </CModal>
    </CRow>
  )
}
const ProtectedCategories = () => {
  return (
    <ProtectRouter>
      <Categories />
    </ProtectRouter>
  )
}
export default ProtectedCategories

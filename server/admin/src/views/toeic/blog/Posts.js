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
  CInputGroup,
  CFormInput,
  CFormSelect,
  CModal,
  CModalHeader,
  CModalBody,
  CModalFooter,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import {
  cilPencil,
  cilTrash,
  cilPlus,
  cilSearch,
  cilCheckCircle,
  cilCircle,
  cilClock,
  cilPen,
} from '@coreui/icons'
import { useNavigate } from 'react-router-dom'
import DOMPurify from 'dompurify'
import ProtectRouter from '../../../wrapper/ProtectRouter'
import instance from '../../../configs/axios.instance'
import { endpoint } from '../../../api'
import { formatDate, formatDateTime } from '../../../utils/formatDate'
import './quill-custom.css'
import { toast } from 'react-toastify'

const Posts = () => {
  const navigate = useNavigate()
  const [posts, setPosts] = useState([])

  const [searchTerm, setSearchTerm] = useState('')
  const [categoryFilter, setCategoryFilter] = useState('')
  const [statusFilter, setStatusFilter] = useState('')
  const [showPreviewModal, setShowPreviewModal] = useState(false)
  const [selectedPost, setSelectedPost] = useState(null)
  const [currentPage, setCurrentPage] = useState(1)
  const postsPerPage = 6

  const handleCreateNew = () => {
    navigate('/toeic/blog/create')
  }

  const handleEdit = (postId) => {
    navigate(`/toeic/blog/edit/${postId}`)
  }

  const handleDelete = async (postId) => {
    if (window.confirm('Are you sure you want to delete this post?')) {
      let { data } = await instance.delete(endpoint.blog.delete + '/' + postId)
      if (data) {
        setPosts(posts.filter((post) => post.id !== postId))
        toast.success('Post deleted successfully')
      } else {
        toast.error('Failed to delete post')
      }
    }
  }
  const handlePageChange = (page) => {
    setCurrentPage(page)
  }
  const handlePreview = (post) => {
    setSelectedPost(post)
    setShowPreviewModal(true)
  }

  const filteredPosts = posts.filter((post) => {
    const matchesSearch = post.title.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesCategory = !categoryFilter || post.category === categoryFilter
    const status = post.isPublished ? 'Published' : 'Draft'
    const matchesStatus = !statusFilter || status === statusFilter
    return matchesSearch && matchesCategory && matchesStatus
  })
  const startIndex = (currentPage - 1) * postsPerPage
  const endIndex = startIndex + postsPerPage
  const currentPosts = filteredPosts.slice(startIndex, endIndex)
  useEffect(() => {
    async function fetchPosts() {
      const { data } = await instance.get(endpoint.blog.get)
      console.log(data)
      setPosts(data)
    }
    fetchPosts()
  }, [])
  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <div className="d-flex justify-content-between align-items-center">
              <strong>Blog Posts</strong>
              <CButton
                color="primary"
                className="d-flex align-items-center gap-2"
                onClick={handleCreateNew}
              >
                <CIcon icon={cilPlus} /> Create New Post
              </CButton>
            </div>
          </CCardHeader>
          <CCardBody>
            {/* Filters */}
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
                value={categoryFilter}
                onChange={(e) => setCategoryFilter(e.target.value)}
              >
                <option value="">All Categories</option>
                <option value="Study Tips">Study Tips</option>
                <option value="Listening">Listening</option>
                <option value="Reading">Reading</option>
                <option value="Grammar">Grammar</option>
                <option value="Vocabulary">Vocabulary</option>
                <option value="Speaking">Speaking</option>
                <option value="Writing">Writing</option>
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

            {/* Posts Table */}
            <CTable hover responsive className="align-middle">
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Title</CTableHeaderCell>
                  <CTableHeaderCell>Category</CTableHeaderCell>
                  <CTableHeaderCell>Author</CTableHeaderCell>
                  <CTableHeaderCell>Status</CTableHeaderCell>
                  <CTableHeaderCell>Views</CTableHeaderCell>
                  {/* <CTableHeaderCell>Likes</CTableHeaderCell> */}
                  <CTableHeaderCell>Publish Date</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {currentPosts.map((post) => (
                  <CTableRow key={post.id}>
                    <CTableDataCell>{post.title}</CTableDataCell>
                    <CTableDataCell>
                      <CBadge color="info" className="px-2 py-1">
                        {post.category}
                      </CBadge>
                    </CTableDataCell>
                    <CTableDataCell>{post.author}</CTableDataCell>
                    <CTableDataCell>
                      <CBadge
                        color={post.isPublished === true ? 'success' : 'warning'}
                        className="px-2 py-1"
                      >
                        {post.isPublished ? 'Published' : 'Draft'}
                      </CBadge>
                    </CTableDataCell>
                    <CTableDataCell>{post.view}</CTableDataCell>
                    <CTableDataCell>{formatDateTime(post.createdAt)}</CTableDataCell>
                    <CTableDataCell>
                      <div className="d-flex gap-2">
                        <CButton
                          color="info"
                          variant="ghost"
                          size="sm"
                          onClick={() => handlePreview(post)}
                        >
                          <CIcon icon={cilSearch} />
                        </CButton>
                        {/* <CButton color="primary" size="sm" variant="ghost">
                          <CIcon
                            icon={post.isPublished === true ? cilCheckCircle : cilPen}
                            style={{ color: post.isPublished === true ? 'green' : 'gray' }}
                          />
                        </CButton> */}
                        <CButton
                          color="primary"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleEdit(post.id)}
                        >
                          <CIcon icon={cilPencil} />
                        </CButton>
                        <CButton
                          color="danger"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleDelete(post.id)}
                        >
                          <CIcon icon={cilTrash} />
                        </CButton>
                      </div>
                    </CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
            <div>
              {Array.from({ length: Math.ceil(filteredPosts.length / postsPerPage) }, (_, i) => (
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
            {/* Preview Modal */}
            <CModal visible={showPreviewModal} onClose={() => setShowPreviewModal(false)} size="lg">
              <CModalHeader closeButton>
                <h5 className="mb-0">Preview Post</h5>
              </CModalHeader>
              <CModalBody>
                {selectedPost && (
                  <div className="blog-preview">
                    <h1 className="blog-title">{selectedPost.title}</h1>
                    <div className="relative w-full h-64 md:h-96 mb-4">
                      <img
                        src={selectedPost.image}
                        alt={selectedPost.title}
                        style={{
                          width: '100%',
                          height: 'auto',
                          objectFit: 'cover',
                          borderRadius: '10px',
                        }}
                      />
                    </div>
                    <div className="blog-meta mb-4">
                      <span className="blog-author">
                        <i className="fas fa-user me-2"></i>
                        {selectedPost.author}
                      </span>
                      <span className="blog-date ms-3">
                        <i className="fas fa-calendar-alt me-2"></i>
                        {selectedPost.createdAt}
                      </span>
                    </div>

                    <div className="mb-3">
                      <CBadge color="info" className="px-3 py-2">
                        {selectedPost.category}
                      </CBadge>
                    </div>

                    <div
                      className="ql-editor blog-content"
                      dangerouslySetInnerHTML={{
                        __html: DOMPurify.sanitize(selectedPost.content),
                      }}
                    />
                  </div>
                )}
              </CModalBody>
              <CModalFooter>
                <CButton color="secondary" onClick={() => setShowPreviewModal(false)}>
                  Close
                </CButton>
              </CModalFooter>
            </CModal>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}
const ProtectedPosts = () => {
  return (
    <ProtectRouter>
      <Posts />
    </ProtectRouter>
  )
}
export default ProtectedPosts

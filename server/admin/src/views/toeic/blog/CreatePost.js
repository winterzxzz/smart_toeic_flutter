import React, { useState, useRef, useCallback } from 'react'
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
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
} from '@coreui/react'
import ReactQuill from 'react-quill'
import 'react-quill/dist/quill.snow.css'
import 'react-quill/dist/quill.bubble.css'
import DOMPurify from 'dompurify'
import './quill-custom.css'
import { createBlogPost } from '../../../api/Blog/blog'
import axios from 'axios'
import ProtectRouter from '../../../wrapper/ProtectRouter'
import instance from '../../../configs/axios.instance'
import { endpoint } from '../../../api'
import { toast } from 'react-toastify'
const CreatePost = () => {
  const [activeTab, setActiveTab] = useState(1)
  const [formData, setFormData] = useState({
    title: '',
    category: '',
    content: '',
    image: '',
    author: '',
    description: '',
    isPublished: true,
    // likes: 0
  })
  const quillRef = useRef(null)

  const handleImageUpload = useCallback(async () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'image/*')
    input.click()

    input.onchange = async () => {
      const file = input.files?.[0]
      if (file) {
        try {
          // Create FormData object
          const formData = new FormData()
          formData.append('image', file)

          // Upload to server
          const { data } = await instance.post(endpoint.cloudinary.uploadImage, formData, {
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          })

          // Get the uploaded image URL from response
          const imageUrl = data.url

          // Insert the uploaded image URL into Quill
          const editor = quillRef.current?.getEditor()
          if (editor) {
            const range = editor.getSelection() || { index: editor.getLength(), length: 0 }
            editor.insertEmbed(range.index, 'image', imageUrl)
            editor.setSelection(range.index + 1, 0)
          }
        } catch (error) {
          console.error('Error uploading image:', error)
          // You might want to show an error message to the user
          alert('Failed to upload image. Please try again.')
        }
      }
    }
  }, [])
  const handleInputChange = (name, value) => {
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  const handleEditorChange = (content) => {
    setFormData((prev) => ({
      ...prev,
      content: content,
    }))
  }

  const handleImageChange = async (e) => {
    const file = e.target.files[0]
    const formData = new FormData()
    formData.append('image', file)
    let api = endpoint.cloudinary.uploadImage
    try {
      const { data } = await axios.post(api, formData)
      handleInputChange('image', data.url)
    } catch (error) {
      console.error('Error uploading image:', error)
    }
  }

  const modules = {
    toolbar: {
      container: [
        [{ header: [1, 2, 3, 4, 5, 6, false] }],
        ['bold', 'italic', 'underline', 'strike'],
        [{ color: [] }, { background: [] }],
        [{ font: [] }, { size: ['small', false, 'large', 'huge'] }],
        [{ align: [] }, { indent: '-1' }, { indent: '+1' }],
        [{ list: 'ordered' }, { list: 'bullet' }, { script: 'sub' }, { script: 'super' }],
        ['blockquote', 'code-block'],
        ['link', 'image', 'video'],
        ['clean'],
      ],
      handlers: {
        image: handleImageUpload,
      },
    },
    clipboard: {
      matchVisual: false,
    },
  }

  const formats = [
    'header',
    'bold',
    'italic',
    'underline',
    'strike',
    'color',
    'background',
    'font',
    'size',
    'align',
    'indent',
    'list',
    'bullet',
    'script',
    'blockquote',
    'code-block',
    'link',
    'image',
    'video',
  ]
  function resetForm() {
    setFormData({
      title: '',
      category: '',
      content: '',
      image: '',
      author: '',
      description: '',
    })
  }
  const handleSave = async () => {
    const { title, category, content, author, image, description } = formData

    // // Kiểm tra các trường bắt buộc
    if (!title || !category || !content || !author || !image) {
      alert('Vui lòng điền đầy đủ tất cả các trường.')
      return
    }

    // Tạo đối tượng dữ liệu để gửi
    const postData = {
      title,
      content,
      author,
      image: image || '',
      category,
      isPublished: formData.isPublished,
      description,
    }
    try {
      const response = await createBlogPost(postData)
      resetForm()
      toast.success('Create post success!')
    } catch (error) {
      toast.error('Create post failed!')
    }
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4 blog-card">
          <CCardHeader>
            <strong>Create New Post</strong>
          </CCardHeader>
          <CCardBody>
            <CNav variant="tabs" role="tablist" className="custom-tabs">
              <CNavItem>
                <CNavLink active={activeTab === 1} onClick={() => setActiveTab(1)}>
                  Editor
                </CNavLink>
              </CNavItem>
              <CNavItem>
                <CNavLink active={activeTab === 2} onClick={() => setActiveTab(2)}>
                  Preview
                </CNavLink>
              </CNavItem>
            </CNav>

            <CTabContent className="p-4">
              <CTabPane visible={activeTab === 1} role="tabpanel">
                <CForm>
                  <div className="mb-3">
                    <CFormLabel>Title</CFormLabel>
                    <CFormInput
                      value={formData.title}
                      onChange={(e) => handleInputChange('title', e.target.value)}
                      placeholder="Enter title"
                    />
                  </div>
                  <div className="mb-3">
                    <CFormLabel>Description</CFormLabel>
                    <CFormInput
                      value={formData.description}
                      onChange={(e) => handleInputChange('description', e.target.value)}
                      placeholder="Enter description"
                    />
                  </div>

                  <div className="mb-3">
                    <CFormLabel>Category</CFormLabel>
                    <CFormSelect
                      value={formData.category}
                      onChange={(e) => handleInputChange('category', e.target.value)}
                    >
                      <option value="">Select Category</option>
                      <option value="Study Tips">Study Tips</option>
                      <option value="Listening">Listening</option>
                      <option value="Reading">Reading</option>
                      <option value="Grammar">Grammar</option>
                      <option value="Vocabulary">Vocabulary</option>
                      <option value="Speaking">Speaking</option>
                      <option value="Writing">Writing</option>
                    </CFormSelect>
                  </div>

                  <div style={{ display: 'flex', gap: '10px' }}>
                    <div className="mb-3" style={{ width: '50%' }}>
                      <CFormLabel>Author</CFormLabel>
                      <CFormInput
                        value={formData.author}
                        onChange={(e) => handleInputChange('author', e.target.value)}
                        placeholder="Enter author name"
                      />
                    </div>
                    <div className="mb-3" style={{ width: '50%' }}>
                      <CFormLabel htmlFor="isPublished">Publish</CFormLabel>
                      <CFormSelect
                        id="isPublished"
                        name="isPublished"
                        value={formData.isPublished}
                        onChange={(e) => handleInputChange('isPublished', e.target.value)}
                      >
                        <option value="true">True</option>
                        <option value="false">False</option>
                      </CFormSelect>
                    </div>
                  </div>
                  <div className="mb-3">
                    <CFormLabel>Featured Image</CFormLabel>
                    <div className="featured-image-container">
                      <CFormInput
                        type="file"
                        accept="image/*"
                        onChange={handleImageChange}
                        className="mb-3"
                      />
                      {formData.image && (
                        <div className="image-preview-wrapper mb-3">
                          <div className="image-preview-container">
                            <img
                              src={formData.image}
                              alt="Preview"
                              className="featured-image-preview"
                            />
                          </div>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="mb-3">
                    <CFormLabel>Content</CFormLabel>
                    <div
                      className="editor-container"
                      style={{ position: 'relative', paddingBottom: '60px' }}
                    >
                      <ReactQuill
                        ref={quillRef}
                        theme="snow"
                        value={formData.content}
                        onChange={handleEditorChange}
                        modules={modules}
                        formats={formats}
                        style={{
                          height: '400px',
                          marginBottom: '50px',
                        }}
                        placeholder="Write something amazing..."
                        preserveWhitespace={true}
                      />
                    </div>
                  </div>

                  <div
                    className="d-flex gap-2 justify-content-end mt-6"
                    style={{
                      position: 'sticky',
                      bottom: '20px',
                      padding: '10px 0',
                      zIndex: 1000,
                    }}
                  >
                    <CButton color="secondary" variant="outline" onClick={() => handleSave(true)}>
                      Create Post
                    </CButton>
                  </div>
                </CForm>
              </CTabPane>

              <CTabPane visible={activeTab === 2} role="tabpanel">
                <div className="blog-preview animate-fade-in">
                  <h1 className="blog-title">{formData.title}</h1>
                  <p style={{ fontSize: '14px', color: '#666' }}>{formData.description}</p>
                  <div className="blog-meta mb-4">
                    {formData.author && (
                      <span className="blog-author">
                        <i className="fas fa-user me-2"></i>
                        {formData.author}
                      </span>
                    )}
                    {formData.publishDate && (
                      <span className="blog-date ms-3">
                        <i className="fas fa-calendar-alt me-2"></i>
                        {new Date(formData.publishDate).toLocaleDateString('en-US', {
                          year: 'numeric',
                          month: 'long',
                          day: 'numeric',
                        })}
                      </span>
                    )}
                  </div>

                  {formData.category && (
                    <div className="mb-3">
                      <span
                        className="badge bg-info"
                        style={{
                          padding: '8px 16px',
                          fontSize: '0.9rem',
                          borderRadius: '20px',
                        }}
                      >
                        {formData.category}
                      </span>
                    </div>
                  )}

                  {formData.image && (
                    <div
                      className="mb-4"
                      style={{
                        borderRadius: '8px',
                        overflow: 'hidden',
                        boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
                      }}
                    >
                      <img
                        src={formData.image}
                        alt="Featured"
                        style={{
                          maxWidth: '100%',
                          height: 'auto',
                          display: 'block',
                        }}
                      />
                    </div>
                  )}

                  <div
                    className="ql-editor blog-content"
                    style={{
                      fontSize: '1.1rem',
                      lineHeight: '1.8',
                      color: '#2c3e50',
                    }}
                    dangerouslySetInnerHTML={{
                      __html: DOMPurify.sanitize(formData.content),
                    }}
                  />
                </div>
              </CTabPane>
            </CTabContent>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}
const ProtectedCreatePost = () => {
  return (
    <ProtectRouter>
      <CreatePost />
    </ProtectRouter>
  )
}
export default ProtectedCreatePost

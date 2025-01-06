import React from 'react'

// Core pages
const Dashboard = React.lazy(() => import('./views/dashboard/Dashboard'))

// TOEIC Admin Components
const ToeicUsers = React.lazy(() => import('./views/toeic/users/Users'))
const UserDetail = React.lazy(() => import('./views/toeic/users/UserDetail'))

// Exam Management
const ToeicExamList = React.lazy(() => import('./views/toeic/exams/ExamList'))
const ToeicExamCreate = React.lazy(() => import('./views/toeic/exams/ExamCreate'))
const ToeicExamUpload = React.lazy(() => import('./views/toeic/exams/ExamUpload'))
const ExamEdit = React.lazy(() => import('./views/toeic/exams/ExamEdit'))

// Blog Management
const ToeicBlogPosts = React.lazy(() => import('./views/toeic/blog/Posts'))
const ToeicBlogCreate = React.lazy(() => import('./views/toeic/blog/CreatePost.js'))
const ToeicBlogCategories = React.lazy(() => import('./views/toeic/blog/Categories'))
const EditPost = React.lazy(() => import('./views/toeic/blog/EditPost'))

// Flashcard Management
const FlashCardSets = React.lazy(() => import('./views/toeic/flashcards/FlashCardSets'))
const FlashCards = React.lazy(() => import('./views/toeic/flashcards/FlashCards'))

// Other
const ToeicRevenue = React.lazy(() => import('./views/toeic/revenue/Revenue'))

//Login 
const Login = React.lazy(() => import('./views/pages/login/Login'))

const routes = [
  { path: '/', exact: true, name: 'Home' },
  { path: '/dashboard', name: 'Dashboard', element: Dashboard },

  // User Management
  { path: '/toeic/users', name: 'Users Management', element: ToeicUsers },
  { path: '/toeic/users/:userId', name: 'User Detail', element: UserDetail },
  
  // Exam Routes
  { path: '/toeic/exams/list', name: 'Exam List', element: ToeicExamList },
  { path: '/toeic/exams/create', name: 'Create Exam', element: ToeicExamCreate },
  { path: '/toeic/exams/upload', name: 'Upload Exam', element: ToeicExamUpload },
  { path: '/toeic/exams/edit/:examId', name: 'Edit Exam', element: ExamEdit },
  
  // Blog Routes
  { path: '/toeic/blog/posts', name: 'Blog Posts', element: ToeicBlogPosts },
  { path: '/toeic/blog/create', name: 'Create Post', element: ToeicBlogCreate },
  { path: '/toeic/blog/categories', name: 'Blog Categories', element: ToeicBlogCategories },
  { path: '/toeic/blog/edit/:id', name: 'Edit Post', element: EditPost },

  // Flashcard Routes
  { path: '/toeic/flashcards/sets', name: 'Flashcard Sets', element: FlashCardSets },
  { path: '/toeic/flashcards/:id', name: 'Flashcards', element: FlashCards },

  // Analytics
  { path: '/toeic/revenue', name: 'Revenue', element: ToeicRevenue },

  // Login
  { path: '/login', name: 'Login', element: Login },
   
]

export default routes

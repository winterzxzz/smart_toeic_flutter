import React from 'react'
import CIcon from '@coreui/icons-react'
import { cilSpeedometer, cilPeople, cilNotes, cilPencil, cilBook, cilDollar } from '@coreui/icons'
import { CNavItem } from '@coreui/react'

const _nav = [
  {
    component: CNavItem,
    name: 'Dashboard',
    to: '/dashboard',
    icon: <CIcon icon={cilSpeedometer} customClassName="nav-icon" />,
    badge: {
      color: 'info',
    },
  },
  {
    component: CNavItem,
    name: 'Users',
    to: '/toeic/users',
    icon: <CIcon icon={cilPeople} customClassName="nav-icon" />,
  },
  {
    component: CNavItem,
    name: 'Exam Management',
    to: '/toeic/exams/list',
    icon: <CIcon icon={cilNotes} customClassName="nav-icon" />,
  },
  {
    component: CNavItem,
    name: 'Blog Management',
    to: '/toeic/blog/posts',
    icon: <CIcon icon={cilPencil} customClassName="nav-icon" />,
  },
  // {
  //   component: CNavItem,
  //   name: 'Flashcards',
  //   to: '/toeic/flashcards/sets',
  //   icon: <CIcon icon={cilBook} customClassName="nav-icon" />,
  // },
  {
    component: CNavItem,
    name: 'Revenue',
    to: '/toeic/revenue',
    icon: <CIcon icon={cilDollar} customClassName="nav-icon" />,
  },
]

export default _nav

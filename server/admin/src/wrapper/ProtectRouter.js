import React from 'react'
import { Navigate } from 'react-router-dom'

const ProtectRouter = ({ children }) => {
  // Kiểm tra xem người dùng đã đăng nhập hay chưa (dùng localStorage)
  const isLoggedIn = localStorage.getItem('admin_user') // Giả sử bạn lưu token trong localStorage

  // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
  if (!isLoggedIn) {
    return <Navigate to="/login" replace />
  }

  // Nếu đã đăng nhập, render children (nội dung bên trong route)
  return children
}

export default ProtectRouter

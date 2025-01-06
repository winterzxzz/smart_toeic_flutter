import React, { useEffect, useState } from 'react'
import { Navigate } from 'react-router-dom'
import instance from '../configs/axios.instance'
import { endpoint } from '../api'

const ProtectRouter = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(null) // Trạng thái đăng nhập
  const [loading, setLoading] = useState(true) // Trạng thái chờ API

  useEffect(() => {
    const fetchCurrentUser = async () => {
      try {
        const { data } = await instance.get(endpoint.auth.currentUser)
        console.log('User data:', data)
        if (data) {
          setIsAuthenticated(true)
        } else {
          setIsAuthenticated(false)
        }
      } catch (error) {
        console.error('Error fetching current user:', error)
        setIsAuthenticated(false)
      } finally {
        setLoading(false)
      }
    }

    fetchCurrentUser()
  }, [])

  // Hiển thị màn hình loading khi API đang được gọi
  if (loading) {
    return <div>Loading...</div>
  }

  // Chuyển hướng đến trang login nếu không đăng nhập
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  // Nếu đã đăng nhập, render children (nội dung bên trong route)
  return children
}

export default ProtectRouter

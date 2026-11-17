import { useEffect, useState } from 'react'
import { Routes, Route, Link } from 'react-router-dom'
import axiosClient from './api/axiosClient'

function Home() {
  const [status, setStatus] = useState('đang kiểm tra...')

  useEffect(() => {
    axiosClient.get('/health')
      .then((res) => setStatus(res.data.status))
      .catch(() => setStatus('không kết nối được backend'))
  }, [])

  return (
    <div style={{ padding: 24, fontFamily: 'sans-serif' }}>
      <h1>Website thi trực tuyến</h1>
      <p>Backend: <b>{status}</b></p>
      <p><Link to="/login">Đăng nhập</Link></p>
    </div>
  )
}

// TODO: thay bằng các trang thật trong src/pages/(auth|student|teacher|admin)
export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<div style={{ padding: 24 }}>Trang đăng nhập (TV4 làm tuần 4)</div>} />
    </Routes>
  )
}

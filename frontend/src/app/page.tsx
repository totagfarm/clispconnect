'use client'

import { useEffect, useState } from 'react'

export default function Home() {
  const [apiStatus, setApiStatus] = useState<string>('loading')

  useEffect(() => {
    checkAPIStatus()
  }, [])

  const checkAPIStatus = async () => {
    try {
      const response = await fetch('https://api.clispconnect.com/health')
      const data = await response.json()
      if (data.status === 'healthy') {
        setApiStatus('connected')
      } else {
        setApiStatus('unknown')
      }
    } catch (error) {
      setApiStatus('disconnected')
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1e5799] via-[#2989d8] to-[#7db9e8]">
      <div className="container mx-auto px-4 py-12">
        <div className="max-w-5xl mx-auto bg-white rounded-3xl shadow-2xl p-8 md:p-12">
          
          {/* Header */}
          <div className="text-center mb-8">
            <h1 className="text-4xl md:text-5xl font-bold text-[#1e5799] mb-4">
              🇱🇷 LR CLISPConnect
            </h1>
            <p className="text-xl text-gray-600">
              Community Leadership Identification and Structuring Program
            </p>
          </div>

          {/* Status Banner */}
          <div className="bg-green-100 border border-green-300 text-green-800 px-6 py-4 rounded-xl mb-8 text-center">
            <strong>✅ CLISPConnect Ready!</strong> Empowering Liberia&apos;s Communities Through Leadership
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div className="bg-gradient-to-br from-[#1e5799] to-[#2989d8] text-white p-8 rounded-2xl text-center shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-5xl font-bold mb-2">75</div>
              <div className="text-lg opacity-90">Communities</div>
            </div>
            <div className="bg-gradient-to-br from-[#11998e] to-[#38ef7d] text-white p-8 rounded-2xl text-center shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-5xl font-bold mb-2">300+</div>
              <div className="text-lg opacity-90">Leaders</div>
            </div>
            <div className="bg-gradient-to-br from-[#207cca] to-[#2d8f3d] text-white p-8 rounded-2xl text-center shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-5xl font-bold mb-2">15</div>
              <div className="text-lg opacity-90">Counties</div>
            </div>
            <div className="bg-gradient-to-br from-[#f093fb] to-[#f5576c] text-white p-8 rounded-2xl text-center shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-5xl font-bold mb-2">100%</div>
              <div className="text-lg opacity-90">Ready</div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-wrap gap-4 mb-8">
            <a
              href="https://api.clispconnect.com/docs"
              className="bg-[#1e5799] hover:bg-[#164a7a] text-white px-8 py-4 rounded-xl font-semibold transition-colors inline-flex items-center gap-2"
            >
              📄 API Docs
            </a>
            <a
              href="https://api.clispconnect.com/"
              className="bg-[#11998e] hover:bg-[#0d7d74] text-white px-8 py-4 rounded-xl font-semibold transition-colors inline-flex items-center gap-2"
            >
              📊 Dashboard API
            </a>
          </div>

          {/* Pilot Info */}
          <div className="bg-gray-50 border-l-4 border-[#1e5799] p-6 rounded-xl mb-8">
            <h2 className="text-2xl font-bold text-[#1e5799] mb-4 flex items-center gap-2">
              📍 Pilot District #10
            </h2>
            <p className="text-gray-600 mb-6">
              Montserrado County - CLISP Implementation Pilot
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-white p-4 rounded-lg shadow">
                <strong className="text-[#1e5799] block mb-1">Target Communities</strong>
                <span>75</span>
              </div>
              <div className="bg-white p-4 rounded-lg shadow">
                <strong className="text-[#1e5799] block mb-1">Target Leaders</strong>
                <span>75</span>
              </div>
              <div className="bg-white p-4 rounded-lg shadow">
                <strong className="text-[#1e5799] block mb-1">Duration</strong>
                <span>6 months</span>
              </div>
              <div className="bg-white p-4 rounded-lg shadow">
                <strong className="text-[#1e5799] block mb-1">Status</strong>
                <span>Active</span>
              </div>
            </div>
          </div>

          {/* API Status */}
          <div className="bg-blue-50 border-2 border-[#1e5799] p-4 rounded-xl text-center">
            {apiStatus === 'loading' && (
              <span className="text-[#1e5799] font-bold">🔄 Checking API status...</span>
            )}
            {apiStatus === 'connected' && (
              <span className="text-green-600 font-bold">✅ API Connected - Backend is Running!</span>
            )}
            {apiStatus === 'disconnected' && (
              <span className="text-red-600 font-bold">⚠️ API Not Connected - Backend needs to be deployed</span>
            )}
            {apiStatus === 'unknown' && (
              <span className="text-yellow-600 font-bold">⚠️ API Response Unknown</span>
            )}
          </div>

          {/* Footer */}
          <div className="mt-12 text-center text-gray-500 text-sm">
            <p>Community Leadership Empowerment Forum (CLEF)</p>
            <p>In partnership with Ministry of Internal Affairs (MIA), Liberia</p>
            <p className="mt-2">&copy; 2026 CLISPConnect. All rights reserved.</p>
          </div>
        </div>
      </div>
    </div>
  )
}
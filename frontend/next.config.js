/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  images: {
    domains: ['storage.googleapis.com'],
  },
  env: {
    API_URL: process.env.API_URL || 'https://api.clispconnect.com',
  },
}

module.exports = nextConfig
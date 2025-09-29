/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'http://backend:8000/:path*', // Proxy to Backend
      },
    ]
  },
};

module.exports = nextConfig;
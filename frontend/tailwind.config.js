/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#0A3D91',
          hover: '#0C48A8',
          pressed: '#0E4EC1',
        },
        teal: '#1D8F8A',
        green: '#2E7D32',
        red: '#BF2A2A',
        gold: '#D4A73B',
      },
    },
  },
  plugins: [],
}
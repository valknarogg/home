/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: [
    './components/**/*.{js,vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './app.vue',
    './content/**/*.md'
  ],
  theme: {
    extend: {
      colors: {
        // Dark base colors
        dark: {
          50: '#f5f5f5',
          100: '#e7e7e7',
          200: '#d1d1d1',
          300: '#b0b0b0',
          400: '#888888',
          500: '#6d6d6d',
          600: '#5d5d5d',
          700: '#4f4f4f',
          800: '#454545',
          900: '#3d3d3d',
          950: '#0a0a0a',
        },
        // Orange primary colors (funky modern)
        primary: {
          50: '#fff7ed',
          100: '#ffedd5',
          200: '#fed7aa',
          300: '#fdba74',
          400: '#fb923c',
          500: '#f97316', // Main orange
          600: '#ea580c',
          700: '#c2410c',
          800: '#9a3412',
          900: '#7c2d12',
          950: '#431407',
        },
        // Purple accent colors
        accent: {
          50: '#faf5ff',
          100: '#f3e8ff',
          200: '#e9d5ff',
          300: '#d8b4fe',
          400: '#c084fc',
          500: '#a855f7', // Main purple
          600: '#9333ea',
          700: '#7e22ce',
          800: '#6b21a8',
          900: '#581c87',
          950: '#3b0764',
        },
        // Complementary colors
        cyber: {
          pink: '#ff0080',
          cyan: '#00f5ff',
          lime: '#39ff14'
        }
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
        'gradient-primary': 'linear-gradient(135deg, #f97316 0%, #fb923c 100%)',
        'gradient-accent': 'linear-gradient(135deg, #a855f7 0%, #c084fc 100%)',
        'gradient-hero': 'linear-gradient(135deg, #f97316 0%, #a855f7 50%, #7e22ce 100%)',
        'gradient-cyber': 'linear-gradient(135deg, #f97316 0%, #ff0080 50%, #a855f7 100%)',
        'gradient-dark': 'linear-gradient(180deg, #0a0a0a 0%, #1a1a1a 100%)',
        'gradient-shine': 'linear-gradient(90deg, transparent, rgba(249, 115, 22, 0.3), transparent)',
      },
      animation: {
        'gradient': 'gradient 8s linear infinite',
        'gradient-xy': 'gradient-xy 15s ease infinite',
        'shimmer': 'shimmer 2s linear infinite',
        'glow': 'glow 2s ease-in-out infinite alternate',
        'float': 'float 6s ease-in-out infinite',
        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        gradient: {
          '0%, 100%': {
            'background-size': '200% 200%',
            'background-position': 'left center'
          },
          '50%': {
            'background-size': '200% 200%',
            'background-position': 'right center'
          },
        },
        'gradient-xy': {
          '0%, 100%': {
            'background-size': '400% 400%',
            'background-position': 'left center'
          },
          '50%': {
            'background-size': '200% 200%',
            'background-position': 'right center'
          },
        },
        shimmer: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(100%)' }
        },
        glow: {
          'from': {
            'text-shadow': '0 0 10px #f97316, 0 0 20px #f97316, 0 0 30px #f97316',
          },
          'to': {
            'text-shadow': '0 0 20px #a855f7, 0 0 30px #a855f7, 0 0 40px #a855f7',
          }
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' }
        }
      },
      boxShadow: {
        'glow-orange': '0 0 20px rgba(249, 115, 22, 0.5)',
        'glow-purple': '0 0 20px rgba(168, 85, 247, 0.5)',
        'glow-cyber': '0 0 30px rgba(249, 115, 22, 0.3), 0 0 60px rgba(168, 85, 247, 0.3)',
        'inner-glow': 'inset 0 0 20px rgba(249, 115, 22, 0.2)',
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            '--tw-prose-body': theme('colors.gray[300]'),
            '--tw-prose-headings': theme('colors.white'),
            '--tw-prose-links': theme('colors.primary[400]'),
            '--tw-prose-bold': theme('colors.white'),
            '--tw-prose-code': theme('colors.primary[300]'),
            '--tw-prose-pre-bg': theme('colors.dark[900]'),
            maxWidth: 'none',
            color: theme('colors.gray[300]'),
            a: {
              color: theme('colors.primary[400]'),
              '&:hover': {
                color: theme('colors.primary[500]'),
              },
            },
            'code::before': {
              content: '""'
            },
            'code::after': {
              content: '""'
            },
            code: {
              color: theme('colors.primary[300]'),
              backgroundColor: theme('colors.dark[800]'),
              padding: '0.25rem 0.5rem',
              borderRadius: '0.25rem',
              fontWeight: '500',
            },
            pre: {
              backgroundColor: theme('colors.dark[900]'),
              border: `1px solid ${theme('colors.dark[700]')}`,
            }
          }
        }
      })
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

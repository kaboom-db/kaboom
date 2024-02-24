module.exports = {
  darkMode: 'class',
  content: [
    './app/components/**/*.erb',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/javascript/**/*.ts'
  ],
  theme: {
    screens: {
      'sm': '790px',
      'md': '1000px',
      'lg': '1200px'
    },
    extend: {
      colors: {
        primary: '#ef6461',
        'primary-light': '#e58b89',
        secondary: '#e4b363',
        'secondary-light': '#e8c388'
      },
      animation: {
        fadeOut: 'fadeOut 0.5s ease-in-out forwards',
        fadeIn: 'fadeIn 0.5s ease-in-out forwards'
      },
      keyframes: {
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' }
        },
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        }
      },
      transitionProperty: {
        width: 'width'
      },
      backgroundImage: {
        stripes: 'repeating-linear-gradient(45deg, #f2f2f2, #f2f2f2 20px, #ffffff 20px, #ffffff 40px)'
      },
      borderRadius: {
        '4xl': '2rem'
      }
    },
    fontFamily: {
      sans: ['"Montserrat"', 'sans-serif']
    }
  }
}

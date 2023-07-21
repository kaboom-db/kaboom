module.exports = {
  content: [
    './app/components/**/*.erb',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/javascript/**/*.ts'
  ],
  theme: {
    extend: {
      colors: {
        primary: 'rgb(255, 95, 109)',
        'primary-light': 'rgb(252, 153, 162)',
        secondary: 'rgb(255, 195, 113)',
        'secondary-light': 'rgb(249, 213, 162)'
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
      }
    },
    fontFamily: {
      sans: ['"Montserrat"', 'sans-serif']
    }
  }
}

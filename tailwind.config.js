module.exports = {
  content: [
    './app/components/**/*.erb',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        primary: 'rgb(255, 95, 109)',
        secondary: 'rgb(255, 195, 113)'
      },
    },
    fontFamily: {
      sans: ['"Montserrat"', 'sans-serif'],
    },
  }
}

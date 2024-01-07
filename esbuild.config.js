const sassPlugin = require('esbuild-sass-plugin').default
const glob = require('glob')
const path = require('path')
const esbuild = require('esbuild')

const watch = process.argv.includes('--watch')

esbuild.context({
  entryPoints: glob.sync('app/javascript/*.{js,ts}'),
  bundle: true,
  outdir: path.join(process.cwd(), 'app/assets/builds'),
  plugins: [sassPlugin()],
  publicPath: '/assets',
  assetNames: '[name]-[hash].digested',
  target: ['safari15', 'ios15', 'chrome105', 'firefox105']
}).then((context) => {
  context.rebuild().then(() => {
    console.log('Build complete')
    if (watch) {
      context.watch().then(() => {
        console.log('Watching for changes...')
      })
    } else {
      context.dispose()
    }
  })
}).catch(() => process.exit(1))

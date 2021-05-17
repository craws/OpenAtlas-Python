var compressor = require('node-minify')

task('default', [], function() {
  jake.logger.log('Compressing JavaScript files...')
  compressor.minify({
    compressor: 'uglifyjs',
    input: ['L.Control.Geonames.js'],
    output: 'L.Control.Geonames.min.js',
    callback: function(err, min) {
      if (err) {
        jake.logger.console.log(err)
      }
    }
  })
})

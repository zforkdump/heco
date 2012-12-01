
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  bin: recipe.wrap( 'Pig # Activation # Bin', (c, next) ->
    glob "#{c.conf.pig.bin}/*", (err, files) ->
      return next err if err
      files = for file in files
        basename = path.basename file
        destination = "#{c.conf.core.bin}/#{basename}"
        { source: file, destination: destination, exec: true }
      mecano.link files, (err, created) ->
        next err, if created then recipe.OK else recipe.SKIPPED
  )

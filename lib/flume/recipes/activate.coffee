
path = require 'path'
fs = require 'fs'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Flume # Activation # Bin': (c, next) ->
    files = for file in ['flume', 'flume-daemon.sh']
      basename = path.basename file
      option = 
        source: "#{c.conf.flume.bin}/#{basename}"
        destination: "#{c.conf.core.bin}/#{basename}"
        exec: true
    mecano.link files, (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED


path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Hadoop # Desactivation # Bin': (c, next) ->
    console.log c.conf.hadoop.prefix
    glob "#{c.conf.hadoop.bin}/*", (err, files) ->
      console.log files
      files = for file, i in files
        "#{c.conf.core.bin}/#{path.basename file}"
      console.log files
      # mecano.rm files, (err, deleted) ->
      #   next err, if deleted then recipe.OK else recipe.SKIPPED
  'Hadoop # Desactivation # Conf': (c, next) ->
    mecano.rm "#{c.conf.core.etc}/hadoop", (err, deleted) ->
      next err, if deleted then recipe.OK else recipe.SKIPPED
  'Hadoop # Desactivation # Log': (c, next) ->
    mecano.rm "#{c.conf.core.log}/hadoop", (err, deleted) ->
      next err, if deleted then recipe.OK else recipe.SKIPPED

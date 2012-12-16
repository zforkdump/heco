
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Hive # Desactivation # Bin': (c, next) ->
    mecano.rm "#{c.conf.core.bin}/hive", (err, deleted) ->
      next err, if deleted then recipe.OK else recipe.SKIPPED
  'Hive # Desactivation # Conf': (c, next) ->
    mecano.rm "#{c.conf.core.etc}/hive", (err, deleted) ->
      next err, if deleted then recipe.OK else recipe.SKIPPED

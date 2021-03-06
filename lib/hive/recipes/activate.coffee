
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Hive # Activation # Bin': (c, next) ->
    mecano.link
      source: "#{c.conf.hive.bin}/hive"
      destination: "#{c.conf.core.bin}/hive"
      exec: true
      chmod: 0o0755
    , (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED
  'Hive # Activation # Conf': (c, next) ->
    mecano.link
      source: c.conf.hive.conf
      destination: "#{c.conf.core.etc}/hive"
    , (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED

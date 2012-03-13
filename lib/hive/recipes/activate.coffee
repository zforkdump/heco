
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Hive # Activation # Bin', (c, next) ->
        mecano.link
            source: "#{c.conf.hive.bin}/hive"
            destination: "#{c.conf.core.bin}/hive"
            exec: true
            chmod: 0755
        , (err, created) ->
            next err, if created then recipe.OK else recipe.SKIPPED
    )
    conf: recipe.wrap( 'Hive # Activation # Conf', (c, next) ->
        mecano.link
            source: c.conf.hive.conf
            destination: "#{c.conf.core.etc}/hive"
        , (err, created) ->
            next err, if created then recipe.OK else recipe.SKIPPED
    )
    
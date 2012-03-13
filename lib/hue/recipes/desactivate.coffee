
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Hue # Desactivation # Bin', (c, next) ->
        mecano.rm "#{c.conf.core.bin}/hue", (err, deleted) ->
            next err, if deleted then recipe.OK else recipe.SKIPPED
    )
    jars: recipe.wrap( 'Hue # Desactivation # Hadoop jars', (c, next) ->
        glob "#{c.conf.hue.prefix}/desktop/libs/hadoop/java-lib/hue*jar", (err, jars) ->
            jars = for jar, i in jars
                "#{c.conf.hadoop.prefix}/lib/#{path.basename jar}"
            mecano.rm jars, (err, deleted) ->
                next err, if deleted then recipe.OK else recipe.SKIPPED
    )
    conf: recipe.wrap( 'Hue # Desactivation # Conf', (c, next) ->
        mecano.rm "#{c.conf.core.etc}/hue", (err, deleted) ->
            next err, if deleted then recipe.OK else recipe.SKIPPED
    )
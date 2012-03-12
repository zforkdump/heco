
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Hadoop # Desactivation # Bin', (c, next) ->
        glob "#{c.conf.hadoop.bin}/*", (err, files) ->
            files = for file, i in files
                "#{c.conf.core.bin}/#{path.basename file}"
            mecano.rm files, (err, deleted) ->
                next err, if deleted then recipe.OK else recipe.SKIPPED
    )
    conf: recipe.wrap( 'Hadoop # Desactivation # Conf', (c, next) ->
        mecano.rm "#{c.conf.core.etc}/hadoop", (err, deleted) ->
            next err, if deleted then recipe.OK else recipe.SKIPPED
    )
    log: recipe.wrap( 'Hadoop # Desactivation # Log', (c, next) ->
        mecano.rm "#{c.conf.core.log}/hadoop", (err, deleted) ->
            next err, if deleted then recipe.OK else recipe.SKIPPED
    )

glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Thrift # Desactivation # Bin', (c, next) ->
        glob "#{c.conf.thrift.bin}/*", (err, files) ->
            files = for file, i in files
                "#{c.conf.core.bin}/#{path.basename file}"
            mecano.rm files, (err, deleted) ->
                next err, if deleted then recipe.OK else recipe.SKIPPED
    )
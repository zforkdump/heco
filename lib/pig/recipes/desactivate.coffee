
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Pig # Desactivation # Bin', (req, res, next) ->
        glob "#{c.pig.bin}/*", (err, files) ->
            files = for file, i in files
                "#{c.core.bin}/#{path.basename file}"
            mecano.rm files, (err, deleted) ->
                next err, if deleted then recipe.OK else recipe.SKIPPED
    )

path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Thrift # Activation # Bin', (c, next) ->
        glob "#{c.conf.thrift.bin}/*", (err, files) ->
            files = for file in files
                destination = "#{c.conf.core.bin}/#{path.basename file}"
                { source: file, destination: destination, exec: true }
            mecano.link files, (err, linked) ->
                next err, if linked then recipe.OK else recipe.SKIPPED
    )

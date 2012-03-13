
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Oozie # Activation # Bin', (c, next) ->
        glob "#{c.conf.oozie.bin}/*", (err, files) ->
            if err then res.red('FAILED').ln() && next err
            files = for file in files
                basename = path.basename file
                destination = "#{c.conf.core.bin}/#{basename}"
                { source: file, destination: destination, exec: true }
            mecano.link files, (err, created) ->
                next err, if created then recipe.OK else recipe.SKIPPED
    )

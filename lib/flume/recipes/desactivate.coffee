
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    bin: recipe.wrap( 'Flume # Desactivation # Bin', (c, next) ->
        files = for file, i in ['flume', 'flume-daemon.sh']
            "#{c.conf.core.bin}/#{path.basename file}"
        mecano.rm files, (err, deleted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()
    )
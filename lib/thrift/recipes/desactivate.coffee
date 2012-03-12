
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Thrift # Desactivation # Bin: '
        c = req.hmgr.config
        glob "#{c.thrift.bin}/*", (err, files) ->
            files = for file, i in files
                "#{c.core.bin}/#{path.basename file}"
            mecano.rm files, (err, deleted) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
                next()

path = require 'path'
fs = require 'fs'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Thrift # Activation # Bin: '
        c = req.hmgr.config
        glob "#{c.thrift.bin}/*", (err, files) ->
            files = for file in files
                destination = "#{c.core.bin}/#{path.basename file}"
                { source: file, destination: destination, exec: true }
            mecano.link files, (err, linked) ->
                return res.red('FAILED').ln() and next err if err
                res.cyan(if linked then 'OK' else 'SKIPPED').ln()
                next()

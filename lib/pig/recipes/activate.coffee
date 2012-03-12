
path = require 'path'
fs = require 'fs'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Pig # Activation # Bin: '
        c = req.hmgr.config
        glob "#{c.pig.bin}/*", (err, files) ->
            if err then res.red('FAILED').ln() && next err
            files = for file in files
                basename = path.basename file
                destination = "#{c.core.bin}/#{basename}"
                { source: file, destination: destination, exec: true }
            mecano.link files, (err, created) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if created then 'OK' else 'SKIPPED').ln()
                next()

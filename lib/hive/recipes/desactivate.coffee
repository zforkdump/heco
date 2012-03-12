
fs = require 'fs'
path = require 'path'
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Hive # Desactivation # Bin: '
        c = req.hmgr.config
        mecano.rm "#{c.core.bin}/hive", (err, deleted) ->
            res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()
    conf: (req, res, next) ->
        res.blue 'Hive # Desactivation # Conf: '
        c = req.hmgr.config
        mecano.rm "#{c.core.etc}/hive", (err, deleted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()
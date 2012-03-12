
fs = require 'fs'
path = require 'path'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Hue # Desactivation # Bin: '
        c = req.hmgr.config
        mecano.rm "#{c.core.bin}/hue", (err, deleted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()
    jars: (req, res, next) ->
        res.blue 'Hue # Desactivation # Hadoop jars: '
        c = req.hmgr.config
        glob "#{c.hue.prefix}/desktop/libs/hadoop/java-lib/hue*jar", (err, jars) ->
            jars = for jar, i in jars
                "#{c.hadoop.prefix}/lib/#{path.basename jar}"
            mecano.rm jars, (err, deleted) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
                next()
    conf: (req, res, next) ->
        res.blue 'Hue # Desactivation # Conf: '
        c = req.hmgr.config
        mecano.rm "#{c.core.etc}/hue", (err, deleted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()
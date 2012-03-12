
fs = require 'fs'
path = require 'path'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Hue # Activation # Bin: '
        c = req.hmgr.config
        mecano.link
            source: "#{c.hue.prefix}/build/env/bin/supervisor"
            destination: "#{c.core.bin}/hue"
            exec: true
            chmod: 0755
        , (err, created) ->
            if err then res.red('FAILED').ln() && next err
            else
                res.cyan(if created then 'OK' else 'SKIPPED').ln()
                next()
    jars: (req, res, next) ->
        res.blue 'Hue # Activate # Hadoop jars: '
        c = req.hmgr.config
        glob "#{c.hue.prefix}/desktop/libs/hadoop/java-lib/hue*jar", (err, jars) ->
            jars = for jar in jars
                { source: jar, destination: "#{c.hadoop.prefix}/lib/#{path.basename jar}" }
            mecano.link jars, (err, linked) ->
                return res.red('FAILED').ln() and next err if err
                res.cyan(if linked then 'OK' else 'SKIPPED').ln()
                next()
    conf: (req, res, next) ->
        res.blue 'Hue # Activation # Conf: '
        c = req.hmgr.config
        mecano.mkdir
            directory: "#{c.core.etc}/hue"
        , (err, created) ->
            return res.red('FAILED').ln() && next err if err
            mecano.link [
                source: "#{c.hue.prefix}/desktop/conf/hue.ini"
                destination: "#{c.core.etc}/hue/hue.ini"
            ,
                source: "#{c.hue.prefix}/apps/beeswax/conf/hue-beeswax.ini"
                destination: "#{c.core.etc}/hue/hue-beeswax.ini"
            ], (err, created) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if created then 'OK' else 'SKIPPED').ln()
                next()

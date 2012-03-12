
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'Hive # Activation # Bin: '
        c = req.hmgr.config
        mecano.link
            source: "#{c.hive.bin}/hive"
            destination: "#{c.core.bin}/hive"
            exec: true
            chmod: 0755
        , (err, created) ->
            res.red('FAILED').ln() && next err if err
            res.cyan(if created then 'OK' else 'SKIPPED').ln()
            next()
    conf: (req, res, next) ->
        res.blue 'Hive # Activation # Conf: '
        c = req.hmgr.config
        mecano.link
            source: c.hive.conf
            destination: "#{c.core.etc}/hive"
        , (err, created) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if created then 'OK' else 'SKIPPED').ln()
            next()
    
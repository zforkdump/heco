
start_stop = require 'shell/lib/start_stop'

module.exports = (req, res, next) ->
    res.blue 'Hive # Start: '
    c = req.hmgr.config
    start_stop.start
        cmd: "#{c.core.bin}/hive --service hiveserver"
        pidfile: "#{c.hive.pid}"
    , (err, pid) ->
        return res.red('FAILED').ln() && next err if err
        res.cyan(if pid then 'OK' else 'ALREADY STARTED').ln()
        next()

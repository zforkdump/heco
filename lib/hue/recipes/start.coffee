
start_stop = require 'shell/lib/start_stop'

module.exports = (req, res, next) ->
    res.blue 'Hue # Start: '
    c = req.hmgr.config
    start_stop.start
        pidfile: "#{c.hue.pid}/supervisor.pid"
        cmd: "#{c.core.bin}/hue"
    , (err, pid) ->
        return res.red('FAILED').ln() && next err if err
        res.cyan(if pid then 'OK' else 'ALREADY STARTED').ln()
        next()
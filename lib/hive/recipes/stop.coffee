
start_stop = require 'shell/lib/start_stop'

module.exports = (req, res, next) ->
    res.blue 'Hive # Stop: '
    c = req.hmgr.config
    start_stop.stop
        detach: true
        pidfile: "#{c.hive.pid}"
    , (err, stoped) ->
        return res.red('FAILED').ln() && next err if err
        res.cyan(if stoped then 'OK' else 'ALREADY STOPPED').ln()
        next()

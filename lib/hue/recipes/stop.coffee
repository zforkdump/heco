
start_stop = require 'shell/lib/start_stop'

module.exports = (req, res, next) ->
    res.blue 'Hue # Stop: '
    c = req.hmgr.config
    start_stop.stop
        pidfile: "#{c.hue.pid}/supervisor.pid"
    , (err, stoped) ->
        return res.red('FAILED').ln() && next err if err
        res.cyan(if stoped then 'OK' else 'ALREADY STOPPED').ln()
        next()

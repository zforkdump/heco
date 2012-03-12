
exec = require('child_process').exec

module.exports = (req, res, next) ->
    res.blue 'ZooKeeper # Stop: '
    c = req.hmgr.config
    cmd = "#{c.core.bin}/zkServer.sh stop"
    exec cmd, (err, stdout, stderr) ->
        if /could not find file/.test stdout
            message = 'SKIPPED'
        else if /STOPPED/.test stdout
            message = 'OK'
        else return res.red('FAILED').ln() && next err
        res.cyan(message).ln()
        next()

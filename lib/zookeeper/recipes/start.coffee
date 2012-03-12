
fs = require 'fs'
exec = require('child_process').exec

module.exports = (req, res, next) ->
    res.blue 'ZooKeeper # Start: '
    c = req.hmgr.config
    # ZooKeeper doesn't seem to care about `zookeeper.log.dir` in log4j.properties
    fs.readFile "#{c.zookeeper.conf}/log4j.properties", 'ascii', (err, content) ->
        logDir = /zookeeper\.log\.dir=(.*)/.exec(content)[1]
        cmd = "export ZOO_LOG_DIR=#{logDir} && #{c.core.bin}/zkServer.sh start"
        exec cmd, (err, stdout, stderr) ->
            return res.red('FAILED').ln() && next err if err
            if /STARTED/.test stdout
                message = 'OK'
            else if /already running/.test stdout
                message = 'ALREADY STARTED'
            else return res.red('Uncomprensible message').ln()
            res.cyan(message).ln()
            next()


path = require 'path'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'ZooKeeper # Activation # Bin: '
        c = req.hmgr.config
        glob "#{c.zookeeper.bin}/*.sh", (err, files) ->
            links = []
            for file in files
                links.push
                    source: file
                    destination: "#{c.core.bin}/#{path.basename file}"
                    exec: true
                    chmod: 0755
            mecano.link links, (err, created) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if created then 'OK' else 'SKIPPED').ln()
                next()
    conf: (req, res, next) ->
        res.blue 'ZooKeeper # Activation # Conf: '
        c = req.hmgr.config
        mecano.link
            source: "#{c.zookeeper.conf}"
            destination: "#{c.core.etc}/zookeeper"
        , (err, created) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if created then 'OK' else 'SKIPPED').ln()
            next()

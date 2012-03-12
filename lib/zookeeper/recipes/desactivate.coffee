
fs = require 'fs'
path = require 'path'
glob = require('glob').glob
mecano = require 'mecano'

module.exports = 
    bin: (req, res, next) ->
        res.blue 'ZooKeeper # Desactivation # Bin: '
        c = req.hmgr.config
        glob "#{c.zookeeper.bin}/*.sh", (err, files) ->
            files = for file, i in files
                "#{c.core.bin}/#{path.basename file}"
            mecano.rm files, (err, deleted) ->
                return res.red('FAILED').ln() && next err if err
                res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
                next()
    conf: (req, res, next) ->
        res.blue 'ZooKeeper # Desactivation # Conf: '
        c = req.hmgr.config
        mecano.rm "#{c.core.etc}/zookeeper", (err, deleted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if deleted then 'OK' else 'SKIPPED').ln()
            next()

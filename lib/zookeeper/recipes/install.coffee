
path = require 'path'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        res.blue 'ZooKeeper # Install # Download: '
        c = req.hmgr.config
        mecano.download
            source: c.zookeeper.source
            destination: "#{c.core.tmp}/#{path.basename c.zookeeper.source}"
            force: false
        , (err, downloaded) ->
            return next err if err
            message = if downloaded then 'OK' else 'CACHE'
            res.cyan(message).ln()
            next()
    extract: (req, res, next) ->
        res.blue 'ZooKeeper # Install # Extract: '
        c = req.hmgr.config
        mecano.extract
            source: "#{c.core.tmp}/#{path.basename c.zookeeper.source}"
            destination: c.core.lib
            not_if_exists: "#{c.core.lib}/#{path.basename c.zookeeper.source, '.tar.gz'}"
        , (err, extracted) ->
            return next err if err
            message = if extracted then 'OK' else 'CACHE'
            res.cyan(message).ln()
            next()

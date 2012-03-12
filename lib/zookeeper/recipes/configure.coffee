
fs = require 'fs'
path = require 'path'
mecano = require 'mecano'

module.exports = 
    attributes: (req, res, next) ->
        res.blue 'ZooKeeper # Configuration # Attributes: '
        c = req.hmgr.config
        #req.question c.zookeeper.attributes, (attrs) ->
        attrs = c.zookeeper.attributes
        attrs['zookeeper.exec.scratchdir'] = path.resolve c.core.tmp, attrs['zookeeper.exec.scratchdir']
        attrs['zookeeper.log.dir'] = path.resolve c.core.log, attrs['zookeeper.log.dir']
        attrs.dataDir = path.resolve c.core.prefix, attrs.dataDir
        # todo: Only pseudo distributed for now
        attrs.servers = {}
        files = ['zoo.cfg', 'log4j.properties']
        files = for file in files
            {
                source: "#{__dirname}/../templates/#{c.zookeeper.version}/#{file}"
                destination: "#{c.zookeeper.conf}/#{file}"
                context: attrs
            }
        mecano.render files, (err, rendered) ->
            return next err if err
            res.cyan(if rendered then 'OK' else 'SKIPPED').ln()
            next()
    logs: (req, res, next) ->
        res.blue 'ZooKeeper # Configuration # Logs: '
        c = req.hmgr.config
        # ZooKeeper doesn't seem to care about `zookeeper.log.dir` in log4j.properties
        # see start recipe
        fs.readFile "#{c.zookeeper.conf}/log4j.properties", 'ascii', (err, content) ->
            mecano.mkdir
                directory: /zookeeper\.log\.dir=(.*)/.exec(content)[1]
            , (err, created) ->
                return next err if err
                res.cyan(if created then 'OK' else 'SKIPPED').ln()
                next()

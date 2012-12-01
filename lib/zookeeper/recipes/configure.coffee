
fs = require 'fs'
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  attributes: recipe.wrap( 'ZooKeeper # Configuration # Attributes: ', (c, next) ->
    attrs = c.conf.zookeeper.attributes
    attrs['zookeeper.exec.scratchdir'] = path.resolve c.conf.core.tmp, attrs['zookeeper.exec.scratchdir']
    attrs['zookeeper.log.dir'] = path.resolve c.conf.core.log, attrs['zookeeper.log.dir']
    attrs.dataDir = path.resolve c.conf.core.prefix, attrs.dataDir
    # todo: Only pseudo distributed for now
    attrs.servers = {}
    files = ['zoo.cfg', 'log4j.properties']
    files = for file in files
      {
        source: "#{__dirname}/../templates/#{c.conf.zookeeper.version}/#{file}"
        destination: "#{c.conf.zookeeper.conf}/#{file}"
        context: attrs
      }
    mecano.render files, (err, rendered) ->
      next err, if rendered then recipe.OK else recipe.SKIPPED
  )
  logs: recipe.wrap( 'ZooKeeper # Configuration # Logs: ', (c, next) ->
    # ZooKeeper doesn't seem to care about `zookeeper.log.dir` in log4j.properties
    # see start recipe
    fs.readFile "#{c.conf.zookeeper.conf}/log4j.properties", 'ascii', (err, content) ->
      mecano.mkdir
        directory: /zookeeper\.log\.dir=(.*)/.exec(content)[1]
      , (err, created) ->
        return next err if err
        next err, if created then recipe.OK else recipe.SKIPPED
  )

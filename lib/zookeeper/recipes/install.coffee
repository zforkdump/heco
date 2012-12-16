
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'ZooKeeper # Install # Download': (c, next) ->
    mecano.download
      source: c.conf.zookeeper.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.zookeeper.source}"
      force: false
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  'ZooKeeper # Install # Extract': (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.zookeeper.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.zookeeper.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED

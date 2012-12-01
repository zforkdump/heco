
fs = require 'fs'
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  bin: recipe.wrap( 'ZooKeeper # Desactivation # Bin', (c, next) ->
    glob "#{c.conf.zookeeper.bin}/*.sh", (err, files) ->
      files = for file, i in files
        "#{c.conf.core.bin}/#{path.basename file}"
      mecano.rm files, (err, deleted) ->
        next err, if deleted then recipe.OK else recipe.SKIPPED
  )
  conf: recipe.wrap( 'ZooKeeper # Desactivation # Conf', (c, next) ->
    mecano.rm "#{c.conf.core.etc}/zookeeper", (err, deleted) ->
      next err, if deleted then recipe.OK else recipe.SKIPPED
  )


path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'ZooKeeper # Activation # Bin': (c, next) ->
    glob "#{c.conf.zookeeper.bin}/*.sh", (err, files) ->
      links = []
      for file in files
        links.push
          source: file
          destination: "#{c.conf.core.bin}/#{path.basename file}"
          exec: true
          chmod: 0o0755
      mecano.link links, (err, created) ->
        next err, if created then recipe.OK else recipe.SKIPPED
  'ZooKeeper # Activation # Conf': (c, next) ->
    mecano.link
      source: "#{c.conf.zookeeper.conf}"
      destination: "#{c.conf.core.etc}/zookeeper"
    , (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED

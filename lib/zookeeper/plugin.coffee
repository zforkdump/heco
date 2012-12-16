
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'zookeeper activate', 'Activate ZooKeeper', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'ZooKeeper activated'
  ]
  req.shell.cmd 'zookeeper desactivate', 'Desactivate ZooKeeper', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'ZooKeeper desactivated'
  ]
  req.shell.cmd 'zookeeper configure', 'Configure ZooKeeper', [
    recipe "#{__dirname}/recipes/configure"
    shell.routes.prompt 'ZooKeeper configured'
  ]
  req.shell.cmd 'zookeeper install', 'Install ZooKeeper', [
    recipe "#{__dirname}/recipes/install"
    shell.routes.prompt 'ZooKeeper installed'
  ]
  req.shell.cmd 'zookeeper restart', 'Retart ZooKeeper', [
    recipe "#{__dirname}/recipes/stop"
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'ZooKeeper restarted'
  ]
  req.shell.cmd 'zookeeper start', 'Start ZooKeeper', [
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'ZooKeeper started'
  ]
  req.shell.cmd 'zookeeper stop', 'Stop ZooKeeper', [
    recipe "#{__dirname}/recipes/stop"
    shell.routes.prompt 'ZooKeeper stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.zookeeper.prefix = "#{c.core.lib}/#{path.basename c.zookeeper.source, '.tar.gz'}"
  c.zookeeper.bin = "#{c.zookeeper.prefix}/bin"
  c.zookeeper.conf = "#{c.zookeeper.prefix}/conf"
  next()

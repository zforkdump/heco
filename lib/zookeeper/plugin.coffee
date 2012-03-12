
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = hadoop = (req, res, next) ->
    req.shell.cmd 'zookeeper activate', 'Activate ZooKeeper', [
        recipes.activate
        shell.routes.prompt 'ZooKeeper activated'
    ]
    req.shell.cmd 'zookeeper desactivate', 'Desactivate ZooKeeper', [
        recipes.desactivate
        shell.routes.prompt 'ZooKeeper desactivated'
    ]
    req.shell.cmd 'zookeeper configure', 'Configure ZooKeeper', [
        recipes.configure
        shell.routes.prompt 'ZooKeeper configured'
    ]
    req.shell.cmd 'zookeeper install', 'Install ZooKeeper', [
        recipes.install
        shell.routes.prompt 'ZooKeeper installed'
    ]
    req.shell.cmd 'zookeeper restart', 'Retart ZooKeeper', [
        recipes.stop
        recipes.start
        shell.routes.prompt 'ZooKeeper restarted'
    ]
    req.shell.cmd 'zookeeper start', 'Start ZooKeeper', [
        recipes.start
        shell.routes.prompt 'ZooKeeper started'
    ]
    req.shell.cmd 'zookeeper stop', 'Stop ZooKeeper', [
        recipes.stop
        shell.routes.prompt 'ZooKeeper stoped'
    ]
    c = req.hmgr.config
    mecano.merge true, c, require './conf/default'
    versionConfigPath = "#{__dirname}/./conf/#{c.zookeeper.version}.coffee"
    path.exists versionConfigPath, (exists) ->
        mecano.merge true, c, require versionConfigPath if exists
        c.zookeeper.prefix = "#{c.core.lib}/#{path.basename c.zookeeper.source, '.tar.gz'}"
        c.zookeeper.bin = "#{c.zookeeper.prefix}/bin"
        c.zookeeper.conf = "#{c.zookeeper.prefix}/conf"
        next()

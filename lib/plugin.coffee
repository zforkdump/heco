
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
core = require 'heco-core'
hadoop = require 'heco-hadoop'
hbase = require 'heco-hbase'
hive = require 'heco-hive'
pig = require 'heco-pig'
oozie = require 'heco-oozie'
hue = require 'heco-hue'
zookeeper = require 'heco-zookeeper'
thrift = require 'heco-thrift'
#flume = require 'heco-flume'

module.exports = (req, res, next) ->
    app = req.shell
    # Register commands
    app.cmd 'install', 'Install all the Hadoop components', [
        core.recipes.layout
        zookeeper.recipes.install
        hadoop.recipes.install
        hbase.recipes.install
        hive.recipes.install
        pig.recipes.install
        oozie.recipes.install
        hue.recipes.install
        #thrift.recipes.install
        #sqoop.recipes.install
        shell.routes.prompt
    ]
    app.cmd 'uninstall', 'Remove all the Hadoop components', [
        #shell.routes.confirm 'Remove all the components and data'
        zookeeper.recipes.desactivate
        hadoop.recipes.desactivate
        hbase.recipes.desactivate
        hive.recipes.desactivate
        pig.recipes.desactivate
        oozie.recipes.desactivate
        hue.recipes.desactivate
        #thrift.recipes.desactivate
        shell.routes.prompt 'Hadoop has been Uninstalled'
    ]
    app.cmd 'configure', 'Configure all the Hadoop components', [
        zookeeper.recipes.configure
        hadoop.recipes.configure
        hbase.recipes.configure
        hive.recipes.configure
        pig.recipes.configure
        oozie.recipes.configure
        hue.recipes.configure
        #routes.sqoop.configure
        shell.routes.prompt
    ]
    app.cmd 'restart', 'Restart all Hadoop components', [
        zookeeper.recipes.stop
        hadoop.recipes.stop
        hbase.recipes.stop
        hive.recipes.stop
        hue.recipes.stop
        zookeeper.recipes.start
        hadoop.recipes.start
        hbase.recipes.start
        hive.recipes.start
        hue.recipes.start
    ], shell.routes.prompt
    app.cmd 'start', 'Start all Hadoop components', [
        zookeeper.recipes.start
        hadoop.recipes.start
        hbase.recipes.start
        hive.recipes.start
        hue.recipes.start
    ], shell.routes.prompt
    app.cmd 'stop', 'Stop all Hadoop components', [
        hue.recipes.stop
        hive.recipes.stop
        hbase.recipes.stop
        hadoop.recipes.stop
        zookeeper.recipes.stop
        shell.routes.prompt
    ]
    # Enrich with user defined configuration
    mecano.merge true, req.hmgr.config, require "#{__dirname}/../config"
    next()
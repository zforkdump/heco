
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require './recipe'

module.exports = (req, res, next) ->
  app = req.shell
  # Register commands
  app.cmd 'install', 'Install all the Hadoop components', [
    recipe "#{__dirname}/core/recipes/layout"
    recipe "#{__dirname}/zookeeper/recipes/install"
    recipe "#{__dirname}/hadoop/recipes/install"
    recipe "#{__dirname}/hbase/recipes/install"
    recipe "#{__dirname}/hive/recipes/install"
    recipe "#{__dirname}/pig/recipes/install"
    recipe "#{__dirname}/oozie/recipes/install"
    recipe "#{__dirname}/hue/recipes/install"
    #recipe "#{__dirname}/thrift/recipes/install"
    #recipe "#{__dirname}/sqoop/recipes/install"
    shell.routes.prompt
  ]
  app.cmd 'activate', 'Remove all the Hadoop components', [
    #shell.routes.confirm 'Remove all the components and data'
    recipe "#{__dirname}/zookeeper/recipes/activate"
    recipe "#{__dirname}/hadoop/recipes/activate"
    recipe "#{__dirname}/hbase/recipes/activate"
    recipe "#{__dirname}/hive/recipes/activate"
    recipe "#{__dirname}/pig/recipes/activate"
    recipe "#{__dirname}/oozie/recipes/activate"
    recipe "#{__dirname}/hue/recipes/activate"
    #recipe "#{__dirname}/thrift/recipes/activate"
    shell.routes.prompt 'Hadoop has been activated'
  ]
  app.cmd 'desactivate', 'Remove all the Hadoop components', [
    #shell/routes/confirm 'Remove all the components and data'
    recipe "#{__dirname}/zookeeper/recipes/desactivate"
    recipe "#{__dirname}/hadoop/recipes/desactivate"
    recipe "#{__dirname}/hbase/recipes/desactivate"
    recipe "#{__dirname}/hive/recipes/desactivate"
    recipe "#{__dirname}/pig/recipes/desactivate"
    recipe "#{__dirname}/oozie/recipes/desactivate"
    recipe "#{__dirname}/hue/recipes/desactivate"
    recipe "#{__dirname}/thrift/recipes/desactivate"
    shell.routes.prompt 'Hadoop has been desactivated'
  ]
  app.cmd 'configure', 'Configure all the Hadoop components', [
    recipe "#{__dirname}/zookeeper/recipes/configure"
    recipe "#{__dirname}/hadoop/recipes/configure"
    recipe "#{__dirname}/hbase/recipes/configure"
    recipe "#{__dirname}/hive/recipes/configure"
    recipe "#{__dirname}/pig/recipes/configure"
    recipe "#{__dirname}/oozie/recipes/configure"
    recipe "#{__dirname}/hue/recipes/configure"
    #recipe "#{__dirname}/sqoop/configure"
    shell.routes.prompt
  ]
  app.cmd 'restart', 'Restart all Hadoop components', [
    recipe "#{__dirname}/zookeeper/recipes/stop"
    recipe "#{__dirname}/hadoop/recipes/stop"
    recipe "#{__dirname}/hbase/recipes/stop"
    recipe "#{__dirname}/hive/recipes/stop"
    recipe "#{__dirname}/hue/recipes/stop"
    recipe "#{__dirname}/zookeeper/recipes/start"
    recipe "#{__dirname}/hadoop/recipes/start"
    recipe "#{__dirname}/hbase/recipes/start"
    recipe "#{__dirname}/hive/recipes/start"
    recipe "#{__dirname}/hue/recipes/start"
    shell.routes.prompt
  ]
  app.cmd 'start', 'Start all Hadoop components', [
    recipe "#{__dirname}/zookeeper/recipes/start"
    recipe "#{__dirname}/hadoop/recipes/start"
    recipe "#{__dirname}/hbase/recipes/start"
    recipe "#{__dirname}/hive/recipes/start"
    recipe "#{__dirname}/hue/recipes/start"
    shell.routes.prompt
  ]
  app.cmd 'stop', 'Stop all Hadoop components', [
    recipe "#{__dirname}/hue/recipes/stop"
    recipe "#{__dirname}/hive/recipes/stop"
    recipe "#{__dirname}/hbase/recipes/stop"
    recipe "#{__dirname}/hadoop/recipes/stop"
    recipe "#{__dirname}/zookeeper/recipes/stop"
    shell.routes.prompt
  ]
  # Enrich with user defined configuration
  mecano.merge true, req.hmgr.config, require "#{__dirname}/../config"
  next()

path = require 'path'
shell = require 'shell'
mecano = require 'mecano'

module.exports = (req, res, next) ->
  app = req.shell
  # Register commands
  app.cmd 'install', 'Install all the Hadoop components', [
    require './core/recipes/layout'
    require './zookeeper/recipes/install'
    require './hadoop/recipes/install'
    require './hbase/recipes/install'
    require './hive/recipes/install'
    require './pig/recipes/install'
    require './oozie/recipes/install'
    require './hue/recipes/install'
    #require './thrift/recipes/install'
    #require './sqoop/recipes/install'
    shell.routes.prompt
  ]
  app.cmd 'activate', 'Remove all the Hadoop components', [
    #shell.routes.confirm 'Remove all the components and data'
    require './zookeeper/recipes/activate'
    require './hadoop/recipes/activate'
    require './hbase/recipes/activate'
    require './hive/recipes/activate'
    require './pig/recipes/activate'
    require './oozie/recipes/activate'
    require './hue/recipes/activate'
    #require './thrift/recipes/activate'
    shell.routes.prompt 'Hadoop has been activated'
  ]
  app.cmd 'desactivate', 'Remove all the Hadoop components', [
    #shell/routes/confirm 'Remove all the components and data''
    require './zookeeper/recipes/desactivate'
    require './hadoop/recipes/desactivate'
    require './hbase/recipes/desactivate'
    require './hive/recipes/desactivate'
    require './pig/recipes/desactivate'
    require './oozie/recipes/desactivate'
    require './hue/recipes/desactivate'
    require './thrift/recipes/desactivate'
    shell.routes.prompt 'Hadoop has been desactivated'
  ]
  app.cmd 'configure', 'Configure all the Hadoop components', [
    require './zookeeper/recipes/configure'
    require './hadoop/recipes/configure'
    require './hbase/recipes/configure'
    require './hive/recipes/configure'
    require './pig/recipes/configure'
    require './oozie/recipes/configure'
    require './hue/recipes/configure'
    #require './sqoop/configure'
    shell.routes.prompt
  ]
  app.cmd 'restart', 'Restart all Hadoop components', [
    require './zookeeper/recipes/stop'
    require './hadoop/recipes/stop'
    require './hbase/recipes/stop'
    require './hive/recipes/stop'
    require './hue/recipes/stop'
    require './zookeeper/recipes/start'
    require './hadoop/recipes/start'
    require './hbase/recipes/start'
    require './hive/recipes/start'
    require './hue/recipes/start'
    shell.routes.prompt
  ]
  app.cmd 'start', 'Start all Hadoop components', [
    require './zookeeper/recipes/start'
    require './hadoop/recipes/start'
    require './hbase/recipes/start'
    require './hive/recipes/start'
    require './hue/recipes/start'
    shell.routes.prompt
  ]
  app.cmd 'stop', 'Stop all Hadoop components', [
    require './hue/recipes/stop'
    require './hive/recipes/stop'
    require './hbase/recipes/stop'
    require './hadoop/recipes/stop'
    require './zookeeper/recipes/stop'
    shell.routes.prompt
  ]
  # Enrich with user defined configuration
  mecano.merge true, req.hmgr.config, require "#{__dirname}/../config"
  next()
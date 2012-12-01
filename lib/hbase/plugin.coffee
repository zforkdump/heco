
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = (req, res, next) ->
  req.shell.cmd 'hbase activate', 'Stop HBase', [
    recipes.activate
    shell.routes.prompt 'HBase activated'
  ]
  req.shell.cmd 'hbase desactivate', 'Stop HBase', [
    recipes.desactivate
    shell.routes.prompt 'HBase desactivated'
  ]
  req.shell.cmd 'hbase configure', 'Configure HBase', [
    recipes.configure
    shell.routes.prompt 'HBase configured'
  ]
  req.shell.cmd 'hbase restart', 'Retart HBase', [
    recipes.stop
    recipes.start
    shell.routes.prompt 'HBase restarted'
  ]
  req.shell.cmd 'hbase start', 'Start HBase', [
    recipes.start
    shell.routes.prompt 'HBase started'
  ]
  req.shell.cmd 'hbase rest start', 'Start HBase Rest server', [
    recipes.start.rest
    shell.routes.prompt 'HBase Rest server started'
  ]
  req.shell.cmd 'hbase stop', 'Stop HBase', [
    recipes.stop
    shell.routes.prompt 'HBase stoped'
  ]
  req.shell.cmd 'hbase rest stop', 'Start HBase Rest server', [
    recipes.stop.rest
    shell.routes.prompt 'HBase Rest server stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf/default'
  versionConfigPath = "#{__dirname}/./conf/#{c.hbase.version}.coffee"
  path.exists versionConfigPath, (exists) ->
    mecano.merge true, c, require versionConfigPath if exists
    c.hbase.prefix = "#{c.core.lib}/#{path.basename c.hbase.source, '.tar.gz'}"
    c.hbase.bin = "#{c.hbase.prefix}/bin"
    c.hbase.conf = "#{c.hbase.prefix}/conf"
    c.hbase.log = "#{c.hbase.prefix}/logs"
    next()

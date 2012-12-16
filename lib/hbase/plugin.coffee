
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'hbase activate', 'Stop HBase', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'HBase activated'
  ]
  req.shell.cmd 'hbase desactivate', 'Stop HBase', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'HBase desactivated'
  ]
  req.shell.cmd 'hbase configure', 'Configure HBase', [
    recipe "#{__dirname}/recipes/configure"
    shell.routes.prompt 'HBase configured'
  ]
  req.shell.cmd 'hbase restart', 'Retart HBase', [
    recipe "#{__dirname}/recipes/stop"
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'HBase restarted'
  ]
  req.shell.cmd 'hbase start', 'Start HBase', [
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'HBase started'
  ]
  req.shell.cmd 'hbase rest start', 'Start HBase Rest server', [
    recipe "#{__dirname}/recipes/start # HBase # Start # Rest server"
    shell.routes.prompt 'HBase Rest server started'
  ]
  req.shell.cmd 'hbase stop', 'Stop HBase', [
    recipe "#{__dirname}/recipes/stop"
    shell.routes.prompt 'HBase stoped'
  ]
  req.shell.cmd 'hbase rest stop', 'Start HBase Rest server', [
    recipe "#{__dirname}/recipes/stop # HBase # Stop # Rest server"
    shell.routes.prompt 'HBase Rest server stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.hbase.prefix = "#{c.core.lib}/#{path.basename c.hbase.source, '.tar.gz'}"
  c.hbase.bin = "#{c.hbase.prefix}/bin"
  c.hbase.conf = "#{c.hbase.prefix}/conf"
  c.hbase.log = "#{c.hbase.prefix}/logs"
  next()

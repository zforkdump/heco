
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = hadoop = (req, res, next) ->
  req.shell.cmd 'hadoop install', 'Install Hadoop', [
    recipes.install
    shell.routes.prompt 'Hadoop installed'
  ]
  req.shell.cmd 'hadoop activate', 'Activate Hadoop', [
    recipes.activate
    shell.routes.prompt 'Hadoop started'
  ]
  req.shell.cmd 'hadoop desactivate', 'Desactivate Hadoop', [
    recipes.desactivate
    shell.routes.prompt 'Hadoop desactivated'
  ]
  req.shell.cmd 'hadoop configure', 'Configure Hadoop', [
    recipes.configure
    shell.routes.prompt 'Hadoop configured'
  ]
  req.shell.cmd 'hadoop restart', 'Restart Hadoop', [
    recipes.stop
    recipes.start
    shell.routes.prompt 'Hadoop restarted'
  ]
  req.shell.cmd 'hadoop start', 'Start Hadoop', [
    recipes.start
    shell.routes.prompt 'Hadoop started'
  ]
  req.shell.cmd 'hadoop stop', 'Stop Hadoop', [
    recipes.stop
    shell.routes.prompt 'Hadoop stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.hadoop.prefix = "#{c.core.lib}/#{path.basename c.hadoop.source, '.tar.gz'}"
  c.hadoop.bin = "#{c.hadoop.prefix}/bin"
  c.hadoop.conf = "#{c.hadoop.prefix}/conf"
  c.hadoop.logs = "#{c.hadoop.prefix}/logs"
  next()
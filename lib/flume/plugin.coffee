
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = (req, res, next) ->
  req.shell.cmd 'flume activate', 'Activate Flume', [
    recipes.activate
    shell.routes.prompt 'Flume activated'
  ]
  req.shell.cmd 'flume desactivate', 'Desactivate Flume', [
    recipes.desactivate
    shell.routes.prompt 'Flume desactivated'
  ]
  req.shell.cmd 'flume configure', 'Configure Flume', [
    recipes.install
    shell.routes.prompt 'Flume installed'
  ]
  req.shell.cmd 'flume install', 'Desactivate Flume', [
    recipes.install
    shell.routes.prompt 'Flume installed'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.flume.prefix = "#{c.core.lib}/#{path.basename c.flume.source, '.tar.gz'}"
  c.flume.bin = "#{c.flume.prefix}/bin"
  c.flume.conf = "#{c.flume.prefix}/conf"
  c.flume.log = "#{c.core.log}/flume"
  c.flume.pid = "#{c.core.var}/run/flume"
  next()

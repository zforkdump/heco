
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'flume activate', 'Activate Flume', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'Flume activated'
  ]
  req.shell.cmd 'flume desactivate', 'Desactivate Flume', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'Flume desactivated'
  ]
  req.shell.cmd 'flume configure', 'Configure Flume', [
    recipe "#{__dirname}/recipes/configure"
    shell.routes.prompt 'Flume configured'
  ]
  req.shell.cmd 'flume install', 'Desactivate Flume', [
    recipe "#{__dirname}/recipes/install"
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

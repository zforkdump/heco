
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'hive activate', 'Activate Hive', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'Hive activated'
  ]
  req.shell.cmd 'hive desactivate', 'Desactivate Hive', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'Hive desactivated'
  ]
  req.shell.cmd 'hive configure', 'Configure Hive', [
    recipe "#{__dirname}/recipes/configure"
    shell.routes.prompt 'Hive configured'
  ]
  req.shell.cmd 'hive install', 'Install Hive', [
    recipe "#{__dirname}/recipes/install"
    shell.routes.prompt 'Hive installed'
  ]
  req.shell.cmd 'hive start', 'Start Hive', [
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'Hive started'
  ]
  req.shell.cmd 'hive stop', 'Stop Hive', [
    recipe "#{__dirname}/recipes/stop"
    shell.routes.prompt 'Hive stoped'
  ]
  req.shell.cmd 'hive restart', 'Restart Hive', [
    recipe "#{__dirname}/recipes/stop"
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'Hive restarted'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.hive.prefix = "#{c.core.lib}/#{path.basename c.hive.source, '.tar.gz'}"
  c.hive.bin = "#{c.hive.prefix}/bin"
  c.hive.conf = "#{c.hive.prefix}/conf"
  c.hive.lib = "#{c.hive.prefix}/lib"
  c.hive.pid = "#{c.core.var}/run/hive"
  next()

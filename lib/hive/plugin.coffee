
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = (req, res, next) ->
  req.shell.cmd 'hive activate', 'Activate Hive', [
    recipes.activate
    shell.routes.prompt 'Hive activated'
  ]
  req.shell.cmd 'hive desactivate', 'Desactivate Hive', [
    recipes.desactivate
    shell.routes.prompt 'Hive desactivated'
  ]
  req.shell.cmd 'hive configure', 'Configure Hive', [
    recipes.configure
    shell.routes.prompt 'Hive configured'
  ]
  req.shell.cmd 'hive install', 'Install Hive', [
    recipes.install
    shell.routes.prompt 'Hive installed'
  ]
  req.shell.cmd 'hive start', 'Start Hive', [
    recipes.start
    shell.routes.prompt 'Hive started'
  ]
  req.shell.cmd 'hive stop', 'Stop Hive', [
    recipes.stop
    shell.routes.prompt 'Hive stoped'
  ]
  req.shell.cmd 'hive restart', 'Restart Hive', [
    recipes.stop
    recipes.start
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

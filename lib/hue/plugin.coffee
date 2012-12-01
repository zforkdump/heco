
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = (req, res, next) ->
  req.shell.cmd 'hue activate', 'Activate Hue', [
    recipes.activate
    shell.routes.prompt 'Hue activated'
  ]
  req.shell.cmd 'hue desactivate', 'Desactivate Hue', [
    recipes.desactivate
    shell.routes.prompt 'Hue desactivated'
  ]
  req.shell.cmd 'hue configure', 'Configure Hue', [
    recipes.configure
    shell.routes.prompt 'Hue configurated'
  ]
  req.shell.cmd 'hue install', 'Install Hue', [
    recipes.install
    shell.routes.prompt 'Hue installed'
  ]
  req.shell.cmd 'hue restart', 'Restart Hue', [
    recipes.stop
    recipes.start
    shell.routes.prompt 'Hue restarted'
  ]
  req.shell.cmd 'hue start', 'Start Hue', [
    recipes.start
    shell.routes.prompt 'Hue started'
  ]
  req.shell.cmd 'hue stop', 'Stop Hue', [
    recipes.stop
    shell.routes.prompt 'Hue stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf/default'
  versionConfigPath = "#{__dirname}/./conf/#{c.hue.version}.coffee"
  path.exists versionConfigPath, (exists) ->
    mecano.merge true, c, require versionConfigPath if exists
    # Default to ./local/lib/hue-1.2.0.0-cdh3u3
    c.hue.prefix = "#{c.core.lib}/#{path.basename c.hue.source, '.tar.gz'}"
    c.hue.pid = "#{c.core.var}/run/hue"
    next()

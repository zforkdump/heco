
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'hue activate', 'Activate Hue', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'Hue activated'
  ]
  req.shell.cmd 'hue desactivate', 'Desactivate Hue', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'Hue desactivated'
  ]
  req.shell.cmd 'hue configure', 'Configure Hue', [
    recipe "#{__dirname}/recipes/configure"
    shell.routes.prompt 'Hue configurated'
  ]
  req.shell.cmd 'hue install', 'Install Hue', [
    recipe "#{__dirname}/recipes/install"
    shell.routes.prompt 'Hue installed'
  ]
  req.shell.cmd 'hue restart', 'Restart Hue', [
    recipe "#{__dirname}/recipes/stop"
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'Hue restarted'
  ]
  req.shell.cmd 'hue start', 'Start Hue', [
    recipe "#{__dirname}/recipes/start"
    shell.routes.prompt 'Hue started'
  ]
  req.shell.cmd 'hue stop', 'Stop Hue', [
    recipe "#{__dirname}/recipes/stop"
    shell.routes.prompt 'Hue stoped'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.hue.prefix = "#{c.core.lib}/#{path.basename c.hue.source, '.tar.gz'}"
  c.hue.pid = "#{c.core.var}/run/hue"
  next()

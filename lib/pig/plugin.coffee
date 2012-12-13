
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = hadoop = (req, res, next) ->
  req.shell.cmd 'pig activate', 'Activate Pig', [
    recipes.activate
    shell.routes.prompt 'Pig activated'
  ]
  req.shell.cmd 'pig desactivate', 'Desactivate Pig', [
    recipes.desactivate
    shell.routes.prompt 'Pig desactivated'
  ]
  req.shell.cmd 'pig install', 'Desactivate Pig', [
    recipes.install
    shell.routes.prompt 'Pig installed'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.pig.prefix = "#{c.core.lib}/#{path.basename c.pig.source, '.tar.gz'}"
  c.pig.bin = "#{c.pig.prefix}/bin"
  next()


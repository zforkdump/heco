
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = (req, res, next) ->
  req.shell.cmd 'oozie activate', 'Activate Oozie', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'Oozie activated'
  ]
  req.shell.cmd 'oozie desactivate', 'Desactivate Oozie', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'Oozie desactivated'
  ]
  req.shell.cmd 'oozie install', 'Desactivate Oozie', [
    recipe "#{__dirname}/recipes/install"
    shell.routes.prompt 'Pig installed'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.oozie.prefix = "#{c.core.lib}/#{path.basename c.oozie.source, '.tar.gz'}"
  c.oozie.bin = "#{c.oozie.prefix}/bin"
  next()


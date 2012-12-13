
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = hadoop = (req, res, next) ->
  req.shell.cmd 'thrift activate', 'Activate Thrift', [
    recipes.activate
    shell.routes.prompt 'Thrift activated'
  ]
  req.shell.cmd 'thrift desactivate', 'Desactivate Thrift', [
    recipes.desactivate
    shell.routes.prompt 'Thrift desactivated'
  ]
  req.shell.cmd 'thrift install', 'Desactivate Thrift', [
    recipes.install
    shell.routes.prompt 'Thrift installed'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.thrift.prefix = "#{c.core.lib}/#{path.basename c.thrift.source, '.tar.gz'}"
  c.thrift.bin = "#{c.thrift.prefix}/bin"
  next()

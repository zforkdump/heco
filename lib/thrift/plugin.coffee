
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipe = require '../recipe'

module.exports = hadoop = (req, res, next) ->
  req.shell.cmd 'thrift activate', 'Activate Thrift', [
    recipe "#{__dirname}/recipes/activate"
    shell.routes.prompt 'Thrift activated'
  ]
  req.shell.cmd 'thrift desactivate', 'Desactivate Thrift', [
    recipe "#{__dirname}/recipes/desactivate"
    shell.routes.prompt 'Thrift desactivated'
  ]
  req.shell.cmd 'thrift install', 'Desactivate Thrift', [
    recipe "#{__dirname}/recipes/install"
    shell.routes.prompt 'Thrift installed'
  ]
  c = req.hmgr.config
  mecano.merge true, c, require './conf'
  c.thrift.prefix = "#{c.core.lib}/#{path.basename c.thrift.source, '.tar.gz'}"
  c.thrift.bin = "#{c.thrift.prefix}/bin"
  next()

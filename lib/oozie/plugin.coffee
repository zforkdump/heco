
path = require 'path'
shell = require 'shell'
mecano = require 'mecano'
recipes = require './recipes'

module.exports = (req, res, next) ->
    req.shell.cmd 'oozie activate', 'Activate Oozie', [
        recipes.activate
        shell.routes.prompt 'Oozie activated'
    ]
    req.shell.cmd 'oozie desactivate', 'Desactivate Oozie', [
        recipes.desactivate
        shell.routes.prompt 'Oozie desactivated'
    ]
    req.shell.cmd 'oozie install', 'Desactivate Oozie', [
        recipes.install
        shell.routes.prompt 'Pig installed'
    ]
    c = req.hmgr.config
    mecano.merge true, c, require './conf/default'
    versionConfigPath = "#{__dirname}/./conf/#{c.oozie.version}.coffee"
    path.exists versionConfigPath, (exists) ->
        mecano.merge true, c, require versionConfigPath if exists
        c.oozie.prefix = "#{c.core.lib}/#{path.basename c.oozie.source, '.tar.gz'}"
        c.oozie.bin = "#{c.oozie.prefix}/bin"
        next()


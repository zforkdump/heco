
path = require 'path'
shell = require 'shell'

module.exports = (req, res, next) ->
    req.hmgr = {}
    # Add configuration
    c = require './conf/default'
    c.core['prefix'] = path.normalize path.resolve req.shell.set('workspace'), c.core['prefix']
    for key in ['bin', 'etc', 'lib', 'tmp', 'var', 'log']
        c.core[key] = path.normalize path.resolve c.core['prefix'], c.core[key]
    req.hmgr.config = c
    # Add Java route
    #req.shell.cmd 'java', 'Install Java', [
        #recipes.java
        #shell.routes.prompt 'Java installed'
    #]
    next()

each = require 'each'
mecano = require 'mecano'

module.exports = (req, res, next) ->
    c = req.hmgr.config
    each([
        'prefix', 'bin', 'etc', 'lib', 
        'tmp', 'var', 'log'
    ])
    .on 'item', (next, name) ->
        mecano.mkdir
            directory: c.core[name]
            chmod: c.core["#{name}_mask"]
        , (err) ->
            next err
    .on 'both', (err) ->
        next err
            

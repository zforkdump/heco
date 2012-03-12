
assert = require 'assert'

recipe = module.exports = 
    OK: 0
    OK_MSG: 'OK'
    SKIPPED: 1
    SKIPPED_MSG: 'SKIPPED'
    FAILED: 2
    FAILED_MSG: 'FAILED'
    DISABLED: 3
    DISABLED_MSG: 'DISABLED'
    TODO: 4
    TODO_MSG: 'TODO'
    wrap: (options, route) ->
        assert.ok options, 'Missing argument `options`'
        assert.ok route, 'Missing argument `route`'
        options = name: options if typeof options is 'string'
        return (req, res, next) ->
            handle = (err, code) ->
                res.white "#{options.name}: "
                return res.magenta(recipe.FAILED_MSG).ln() and next err if err
                switch code
                    when recipe.OK then res.cyan recipe.OK_MSG
                    when recipe.SKIPPED then res.cyan recipe.SKIPPED_MSG
                    when recipe.FAILED then res.magenta recipe.FAILED_MSG
                    when recipe.TODO then res.cyan recipe.TODO_MSG
                    else res.cyan code
                res.ln()
                next()
            try
                route.call null, {conf: req.hmgr.config}, handle
            catch e then handle e

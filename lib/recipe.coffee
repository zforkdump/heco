
path = require 'path'
assert = require 'assert'
Momo = require './Momo'

recipes = {}

###

Convert one or multiple recipes into Shell routes

Create a recipe

  recipe 'My description', (ctx, next) ->
    dosth (err) ->
      next err, recipe.OK

  # Point to a module which export an object
  recipe 'path/to/recipe # recipe name'

Create multiple recipes

  recipe 'path/to/my/recipe'
  # Or
  recipe require 'path/to/my/recipe'
  # Where the recipe my look like
  module.exports =
    'My action': (ctx, next) ->
      dosth (err) ->
        next err, recipe.OK

###

self = @

module.exports = recipe = (options, route) ->
  if arguments.length is 1
    if typeof arguments[0] is 'object'
      return recipe k, v for k, v of arguments[0]
    else if typeof arguments[0] is 'string'
      throw Error 'Unacceptable relative path' if arguments[0].substr(0, 1) is '.'
      if matches = /^(.*?)\s*#\s*(.*)$/.exec arguments[0]
        arguments[0] = matches[1]
        key = matches[2]
      actions = require path.resolve path.dirname(module.parent.filename), arguments[0]
      if typeof actions is 'function' # Shell route
        actions = actions[0]
      else if typeof actions is 'object' and not Array.isArray actions
        if key
          recipe key, actions[key]
        else
          recipe description, action for description, action of actions
      else
        throw new Error 'Invalid recipe arguments'
  else
    assert.ok options, 'Missing argument `options`'
    assert.ok route, 'Missing argument `route`'
    options = name: options if typeof options is 'string'
    recipes[options.name] = (req, res, next) ->
      handle = (err, code) ->
        res.white "#{options.name}: "
        return res.magenta(recipe.FAILED_MSG).ln() and next err if err
        switch code
          when recipe.OK then res.cyan recipe.OK_MSG
          when recipe.SKIPPED then res.cyan recipe.SKIPPED_MSG
          when recipe.FAILED then res.magenta recipe.FAILED_MSG
          when recipe.TODO then res.cyan recipe.TODO_MSG
          when recipe.PARTIAL then res.cyan recipe.PARTIAL_MSG
          else res.cyan code
        res.ln()
        next()
      try
        route.call null, {conf: req.hmgr.config}, handle
      catch e then handle e
recipe.OK = 0
recipe.OK_MSG = 'OK'
recipe.SKIPPED = 1
recipe.SKIPPED_MSG = 'SKIPPED'
recipe.FAILED = 2
recipe.FAILED_MSG = 'FAILED'
recipe.DISABLED = 3
recipe.DISABLED_MSG = 'DISABLED'
recipe.TODO = 4
recipe.TODO_MSG = 'TODO'
recipe.PARTIAL = 5
recipe.PARTIAL_MSG = 'PARTIAL'

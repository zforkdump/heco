
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Pig # Configuration', (c, next) ->
    next null, recipe.TODO
)
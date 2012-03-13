
start_stop = require 'shell/lib/start_stop'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Hue # Stop', (c, next) ->
    start_stop.stop
        pidfile: "#{c.conf.hue.pid}/supervisor.pid"
    , (err, stoped) ->
        next err, if stoped then recipe.OK else recipe.SKIPPED
)

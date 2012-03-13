
start_stop = require 'shell/lib/start_stop'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Hive # Stop', (c, next) ->
    start_stop.stop
        detach: true
        pidfile: "#{c.conf.hive.pid}"
    , (err, stoped) ->
        next err, if stoped then recipe.OK else recipe.SKIPPED
)

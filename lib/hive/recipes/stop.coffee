
start_stop = require 'shell/lib/start_stop'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Hive # Stop', (c, next) ->
  start_stop.stop
    pidfile: "#{c.conf.hive.pid}"
    detached: true
  , (err, stoped) ->
    next err, if stoped then recipe.OK else recipe.SKIPPED
)

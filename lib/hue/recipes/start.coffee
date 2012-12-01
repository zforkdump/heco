
start_stop = require 'shell/lib/start_stop'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Hue # Start', (c, next) ->
  start_stop.start
    pidfile: "#{c.conf.hue.pid}/supervisor.pid"
    cmd: "#{c.conf.core.bin}/hue"
  , (err, pid) ->
    next err, if pid then recipe.OK else recipe.SKIPPED
)

start_stop = require 'shell/lib/start_stop'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'Hive # Start', (c, next) ->
    start_stop.start
        cmd: "#{c.conf.core.bin}/hive --service hiveserver"
        pidfile: "#{c.conf.hive.pid}"
    , (err, pid) ->
        next err, if pid then recipe.OK else recipe.SKIPPED
)

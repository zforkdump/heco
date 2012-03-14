
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
    master: recipe.wrap( 'HBase # Start # Master', (c, next) ->
        mecano.exec
            cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} start master"
            cwd: c.conf.core.bin
            code: [0, 1]
        , (err, executed, stdout, stderr) ->
            if /starting master/.test stdout
                code = recipe.OK
            else if /master running/.test stdout
                code = recipe.SKIPPED
            else code = recipe.FAILED
            next err, code
    )
    regionserver: recipe.wrap( 'HBase # Start # RegionServer', (c, next) ->
        mecano.exec
            cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} start regionserver"
            cwd: c.conf.core.bin
            code: [0, 1]
        , (err, executed, stdout, stderr) ->
            if /starting regionserver/.test stdout
                code = recipe.OK
            else if /regionserver running/.test stdout
                code = recipe.SKIPPED
            else code = recipe.FAILED
            next err, code
    )
    rest: recipe.wrap( 'HBase # Start # Rest server', (c, next) ->
        mecano.exec
            cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} start rest"
            cwd: c.conf.core.bin
            code: [0, 1]
        , (err, executed, stdout, stderr) ->
            if /starting rest/.test stdout
                code = recipe.OK
            else if /rest running/.test stdout
                code = recipe.SKIPPED
            else code = recipe.FAILED
            next err, code
    )

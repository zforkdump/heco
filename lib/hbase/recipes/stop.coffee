
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
  master: recipe.wrap( 'HBase # Stop # Master', (c, next) ->
    mecano.exec 
      cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} stop master"
      cwd: c.conf.core.bin
      code: [0, 1]
    , (err, executed, stdout, stderr) ->
      if /stopping master/.test stdout
        code = recipe.OK
      else if /no master to stop/.test stdout
        code = recipe.SKIPPED
      else code = recipe.FAILED
      next err, code
  )
  regionserver: recipe.wrap( 'HBase # Stop # RegionServer', (c, next) ->
    mecano.exec
      cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} stop regionserver"
      cwd: c.conf.core.bin
      code: [0, 1]
    , (err, executed, stdout, stderr) ->
      if /stopping regionserver/.test stdout
        code = recipe.OK
      else if /no regionserver to stop/.test stdout
        code = recipe.SKIPPED
      else code = recipe.FAILED
      next err, code
  )
  rest: recipe.wrap( 'HBase # Stop # Rest server', (c, next) ->
    mecano.exec
      cmd: "./hbase-daemon.sh --config #{c.conf.hbase.conf} stop rest"
      cwd: c.conf.core.bin
      code: [0, 1]
    , (err, executed, stdout, stderr) ->
      if /stopping rest/.test stdout
        code = recipe.OK
      else if /no rest to stop/.test stdout
        code = recipe.SKIPPED
      else code = recipe.FAILED
      next err, code
  )
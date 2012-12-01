
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = recipe.wrap( 'ZooKeeper # Stop', (c, next) ->
  mecano.exec
    cmd: './zkServer.sh stop'
    cwd: c.conf.core.bin
  , (err, executed, stdout, stderr) ->
    if /STOPPED/.test stdout
      code = recipe.OK
    else if /could not find file/.test stdout
      code = recipe.SKIPPED
    else code = recipe.FAILED
    next err, code
)

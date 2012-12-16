
fs = require 'fs'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'ZooKeeper # Start': (c, next) ->
    # ZooKeeper doesn't seem to care about `zookeeper.log.dir` in log4j.properties
    fs.readFile "#{c.conf.zookeeper.conf}/log4j.properties", 'ascii', (err, content) ->
      logDir = /zookeeper\.log\.dir=(.*)/.exec(content)[1]
      mecano.exec 
        cmd: "export ZOO_LOG_DIR=#{logDir} && ./zkServer.sh start"
        cwd: c.conf.core.bin
      , (err, executed, stdout, stderr) ->
        if /STARTED/.test stdout
          code = recipe.OK
        else if /already running/.test stdout
          code = recipe.SKIPPED
        else code = recipe.FAILED
        next err, code

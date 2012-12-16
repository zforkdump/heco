
mecano = require 'mecano'
recipe = require '../../recipe'

start = (args) ->
  (c, next) ->
    mecano.exec
      cmd: "./hadoop-daemon.sh #{args}"
      cwd: c.conf.core.bin
      code: [0, 1]
    , (err, executed, stdout, stderr) ->
      if stdout and /^starting/.test(stdout)
        code = recipe.OK
      else if stdout and /^\w+ running/.test(stdout)
        code = recipe.SKIPPED
      else err = new Error "Failed to start Hadoop"
      next err, code

module.exports =
  'Hadoop # Start # Namenode': start 'start namenode'
  'Hadoop # Start # Datanode': start 'start datanode'
  'Hadoop # Start # Secondary Namenode': start '--hosts masters start secondarynamenode'
  'Hadoop # Start # Jobtracker': start 'start jobtracker'
  'Hadoop # Start # Tasktracker': start 'start tasktracker'

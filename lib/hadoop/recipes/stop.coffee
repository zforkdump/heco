
{exec} = require 'child_process'
mecano = require 'mecano'
recipe = require '../../recipe'

stop = (args) ->
  (c, next) ->
    mecano.exec
      cmd: "./hadoop-daemon.sh #{args}"
      cwd: c.conf.core.bin
    , (err, executed, stdout, stderr) ->
      if stdout and /^stopping/.exec stdout
        code = recipe.OK
      else if stdout
        code = recipe.SKIPPED
      next err, code

module.exports = 
  'Hadoop # Stop # Tasktracker': stop 'stop tasktracker'
  'Hadoop # Stop # Jobtracker': stop 'stop jobtracker'
  'Hadoop # Stop # Secondary Namenode': stop '--hosts masters stop secondarynamenode'
  'Hadoop # Stop # Datanode': stop 'stop datanode'
  'Hadoop # Stop # Namenode': stop 'stop namenode'

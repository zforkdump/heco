
{exec} = require 'child_process'
mecano = require 'mecano'
recipe = require '../../recipe'

stop = (name, args) ->
    recipe.wrap "Hadoop # Stop # #{name}", (c, next) ->
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
    namenode: stop 'Namenode', 'stop namenode'
    datanode: stop 'Datanode', 'stop datanode'
    secondarynamenode: stop 'Secondary Namenode', '--hosts masters stop secondarynamenode'
    jobtracker: stop 'Jobtracker', 'stop jobtracker'
    tasktracker: stop 'Tasktracker', 'stop tasktracker'
            


mecano = require 'mecano'
recipe = require '../../recipe'

start = (name, args) ->
    recipe.wrap "Hadoop # Start # #{name}", (c, next) ->
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
    namenode: start 'Namenode', 'start namenode'
    datanode: start 'Datanode', 'start datanode'
    secondarynamenode: start 'Secondary Namenode', '--hosts masters start secondarynamenode'
    jobtracker: start 'Jobtracker', 'start jobtracker'
    tasktracker: start 'Tasktracker', 'start tasktracker'

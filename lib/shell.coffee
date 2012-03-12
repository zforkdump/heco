
shell = require 'shell'

app = module.exports = shell { workspace: "#{__dirname}/../", chdir: true }
app.configure ->
    app.use shell.history shell: app
    app.use shell.completer shell: app
    app.use require 'heco-core/lib/plugin'
    app.use require 'heco-hadoop/lib/plugin'
    app.use require 'heco-hbase/lib/plugin'
    app.use require 'heco-hive/lib/plugin'
    app.use require 'heco-pig/lib/plugin'
    app.use require 'heco-oozie/lib/plugin'
    app.use require 'heco-hue/lib/plugin'
    app.use require 'heco-zookeeper/lib/plugin'
    app.use require 'heco-thrift/lib/plugin'
    app.use require 'heco-flume/lib/plugin'
    app.use require '../lib/plugin'
    app.use shell.cloud9 port: 4601
    app.use shell.router shell: app
    app.use shell.help
        shell: app
        introduction: true
    app.use shell.error shell: app

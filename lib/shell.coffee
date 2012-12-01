
shell = require 'shell'

app = module.exports = shell { workspace: "#{__dirname}/../", chdir: true }
app.configure ->
  app.use shell.history shell: app
  app.use shell.completer shell: app
  app.use require './core/plugin'
  app.use require './hadoop/plugin'
  app.use require './hbase/plugin'
  app.use require './hive/plugin'
  app.use require './pig/plugin'
  app.use require './oozie/plugin'
  app.use require './hue/plugin'
  app.use require './zookeeper/plugin'
  app.use require './thrift/plugin'
  app.use require './flume/plugin'
  app.use require './plugin'
  app.use shell.cloud9 port: 4501
  app.use shell.router shell: app
  app.use shell.help
    shell: app
    introduction: true
  app.use shell.error shell: app

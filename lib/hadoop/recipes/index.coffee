
recipes = module.exports = {}

recipes.routes =
  configure: require './configure'
  activate: require './activate'
  desactivate: require './desactivate'
  install: require './install'
  start: require './start'
  stop: require './stop'

recipes.start = [
  recipes.routes.start.namenode
  recipes.routes.start.datanode
  recipes.routes.start.secondarynamenode
  recipes.routes.start.jobtracker
  recipes.routes.start.tasktracker
]

recipes.stop = [
  recipes.routes.stop.tasktracker
  recipes.routes.stop.jobtracker
  recipes.routes.stop.secondarynamenode
  recipes.routes.stop.datanode
  recipes.routes.stop.namenode
]

recipes.activate = [
  recipes.routes.activate.bin
  recipes.routes.activate.conf
  recipes.routes.activate.log
  recipes.routes.activate.format
]

recipes.configure = [
  recipes.routes.configure.attributes
  recipes.routes.configure.directories
]

recipes.desactivate = [
  recipes.routes.desactivate.bin
  recipes.routes.desactivate.conf
  recipes.routes.desactivate.log
]

recipes.install = [
  recipes.routes.install.download
  recipes.routes.install.extract
  recipes.configure
  recipes.activate
  recipes.start
]


recipes = module.exports = {}

# http://archive.cloudera.com/cdh/3/hue-1.2.0-cdh3u1/manual.html

recipes.routes =
  activate: require './activate'
  configure: require './configure'
  desactivate: require './desactivate'
  install: require './install'
  start: require './start'
  stop: require './stop'

recipes.start = [
  recipes.routes.start
]

recipes.stop = [
  recipes.routes.stop
]

recipes.activate = [
  recipes.routes.activate.bin
  recipes.routes.activate.jars
  recipes.routes.activate.conf
]

recipes.configure = [
  recipes.routes.configure.attributes
  recipes.routes.configure.dirs
  recipes.routes.configure.database
  recipes.routes.configure.build
]

recipes.desactivate = [
  recipes.routes.desactivate.bin
  recipes.routes.desactivate.jars
  recipes.routes.desactivate.conf
]

recipes.install = [
  recipes.routes.install.download
  recipes.routes.install.extract
  recipes.configure
  recipes.activate
  recipes.start
]

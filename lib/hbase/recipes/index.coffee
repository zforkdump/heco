recipes = module.exports = {}

recipes.routes = 
    activate: require './activate'
    configure: require './configure'
    desactivate: require './desactivate'
    install: require './install'
    start: require './start'
    stop: require './stop'

recipes.start = [
    recipes.routes.start.master
    recipes.routes.start.regionserver
    recipes.routes.start.rest
]
recipes.start.rest = recipes.routes.start.rest

recipes.stop = [
    recipes.routes.stop.rest
    recipes.routes.stop.regionserver
    recipes.routes.stop.master
]
recipes.stop.rest = recipes.routes.stop.rest

recipes.activate = [
    recipes.routes.activate.bin
    recipes.routes.activate.conf
    #recipes.routes.activate.log
]

recipes.configure = [
    recipes.routes.configure.attributes
    recipes.routes.configure.dirs
    recipes.routes.configure.system
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

recipes = module.exports = {}

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
    recipes.routes.activate.conf
]

recipes.configure = [
    recipes.routes.configure.attributes
    recipes.routes.configure.logs
]

recipes.desactivate = [
    recipes.routes.desactivate.bin
    recipes.routes.desactivate.conf
]

recipes.install = [
    recipes.routes.install.download
    recipes.routes.install.extract
    recipes.configure
    recipes.activate
]

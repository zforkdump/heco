
recipes = module.exports = {}

recipes.routes =
    configure: require './configure'
    activate: require './activate'
    desactivate: require './desactivate'
    install: require './install'

recipes.activate = [
    recipes.routes.activate.bin
]

recipes.configure = [
    #recipes.routes.configure.attributes
    #recipes.routes.configure.directories
    #recipes.routes.configure.format
]

recipes.desactivate = [
    recipes.routes.desactivate.bin
]

recipes.install = [
    recipes.routes.install.download
    recipes.routes.install.extract
    recipes.routes.install.build
    recipes.activate
]



recipes = module.exports = {}

recipes.routes =
    activate: require './activate'
    configure: require './configure'
    desactivate: require './desactivate'
    install: require './install'

recipes.activate = [
]

recipes.configure = [
]

recipes.desactivate = [
]

recipes.install = [
    recipes.routes.install.download
    recipes.routes.install.extract
    recipes.configure
    recipes.activate
]


path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
    download: recipe.wrap( 'Hue # Install # Download', (c, next) ->
        mecano.download
            source: c.conf.hue.source
            destination: "#{c.conf.core.tmp}/#{path.basename c.conf.hue.source}"
            force: false
        , (err, downloaded) ->
            next err, if downloaded then recipe.OK else recipe.CACHE
    )
    extract: recipe.wrap( 'Hue # Install # Extract', (c, next) ->
        mecano.extract
            source: "#{c.conf.core.tmp}/#{path.basename c.conf.hue.source}"
            destination: c.conf.core.lib
            not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.hue.source, '.tar.gz'}"
        , (err, extracted) ->
            next err, if extracted then recipe.OK else recipe.CACHE
    )

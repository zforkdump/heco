
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
  download: recipe.wrap( 'Oozie # Install # Download', (c, next) ->
    mecano.download
      source: c.conf.oozie.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.oozie.source}"
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  )
  extract: recipe.wrap( 'Oozie # Install # Extract', (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.oozie.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.oozie.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED
  )

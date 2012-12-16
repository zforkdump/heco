
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Flume # Install # Download': (c, next) ->
    mecano.download
      source: c.conf.flume.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.flume.source}"
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  'Flume # Install # Extract': (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.flume.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.flume.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED

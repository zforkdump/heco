
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Pig # Install # Download': (c, next) ->
    mecano.download
      source: c.conf.pig.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.pig.source}"
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  'Pig # Install # Extract': (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.pig.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.pig.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED

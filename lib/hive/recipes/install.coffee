
path = require 'path'
fs = require 'fs'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
  download: recipe.wrap( 'Hive # Install # Download', (c, next) ->
    mecano.download
      source: c.conf.hive.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.hive.source}"
      force: false
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  )
  download_driver: recipe.wrap( 'Hive # Install # Download MySQL driver', (c, next) ->
    name = /\/([\w\d-\.]+.tar.gz)/.exec(c.conf.hive.attributes.database_driver_url)[1]
    mecano.download
      source: c.conf.hive.attributes.database_driver_url
      destination: "#{c.conf.core.tmp}/#{name}"
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  )
  extract: recipe.wrap( 'Hive # Install # Extract', (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.hive.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.hive.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED
  )
  extract_driver: recipe.wrap( 'Hive # Install # Extract MySQL driver', (c, next) ->
    name = /\/([\w\d-\.]+.tar.gz)/.exec(c.conf.hive.attributes.database_driver_url)[1]
    mecano.extract
      source: "#{c.conf.core.tmp}/#{name}"
      destination: c.conf.core.tmp
      not_if_exists: "#{c.conf.hive.lib}/#{path.basename name, '.tar.gz'}-bin.jar"
    , (err, extracted) ->
      return next err, recipe.SKIPPED if err or not extracted
      fs.rename "#{c.conf.core.tmp}/#{path.basename name, '.tar.gz'}/#{path.basename name, '.tar.gz'}-bin.jar", "#{c.conf.hive.lib}/#{path.basename name, '.tar.gz'}-bin.jar", (err) ->
        next err if err
        mecano.rm "#{c.conf.core.tmp}/#{path.basename name, '.tar.gz'}", (err, removed) ->
          err = new Error 'Failed to clear archive' if not err and not removed
          next err, recipe.OK
  )

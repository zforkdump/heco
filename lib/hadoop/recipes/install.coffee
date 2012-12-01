
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

###
Install the various Hadoop components.

LZO resources:
https://github.com/cloudera/hadoop-lzo/
http://code.google.com/a/apache-extras.org/p/hadoop-gpl-compression/wiki/FAQ?redir=1
###
module.exports =
  download: recipe.wrap( 'Hadoop # Install # Download', (c, next) ->
    mecano.download
      source: c.conf.hadoop.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.hadoop.source}"
      force: false
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  )
  extract: recipe.wrap( 'Hadoop # Install # Extract', (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.hadoop.source}"
      destination: c.conf.core.lib
      not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.hadoop.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED
  )

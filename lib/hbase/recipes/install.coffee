
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

###
https://ccp.cloudera.com/display/CDHDOC/HBase+Installation
###
module.exports =
    download: recipe.wrap( 'HBase # Install # Download', (c, next) ->
        destination = "#{c.conf.core.tmp}/#{path.basename c.conf.hbase.source}"
        mecano.download
            source: c.conf.hbase.source
            destination: destination
        , (err, downloaded) ->
            next err, if downloaded then recipe.OK else recipe.SKIPPED
    )
    extract: recipe.wrap( 'HBase # Install # Extract', (c, next) ->
        mecano.extract
            source: "#{c.conf.core.tmp}/#{path.basename c.conf.hbase.source}"
            destination: c.conf.core.lib
            not_if_exists: "#{c.conf.core.lib}/#{path.basename c.conf.hbase.source, '.tar.gz'}"
        , (err, extracted) ->
            next err, if extracted then recipe.OK else recipe.SKIPPED
    )

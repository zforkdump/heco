
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  'Thrift # Install # Download': (c, next) ->
    mecano.download
      source: c.conf.thrift.source
      destination: "#{c.conf.core.tmp}/#{path.basename c.conf.thrift.source}"
      force: false
    , (err, downloaded) ->
      next err, if downloaded then recipe.OK else recipe.SKIPPED
  'Thrift # Install # Extract': (c, next) ->
    mecano.extract
      source: "#{c.conf.core.tmp}/#{path.basename c.conf.thrift.source}"
      destination: c.conf.core.tmp
      not_if_exists: "#{c.conf.core.tmp}/#{path.basename c.conf.thrift.source, '.tar.gz'}"
    , (err, extracted) ->
      next err, if extracted then recipe.OK else recipe.SKIPPED
  'Thrift # Install # Build': (c, next) ->
    mecano.exec 
      cmd: [
        'chmod u+x install-sh'
        'chmod u+x configure'
        "./configure --prefix=#{c.conf.thrift.prefix} --without-python --without-php"
        'make'
        'make install'
      ].join(' && ')
      cwd: "#{c.conf.core.tmp}/#{path.basename c.conf.thrift.source, '.tar.gz'}"
      not_if_exists: c.conf.thrift.prefix
    , (err, executed) ->
      next err, if executed then recipe.OK else recipe.SKIPPED

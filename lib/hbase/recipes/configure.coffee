
fs = require 'fs'
path = require 'path'
{exec} = require 'child_process'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
  'HBase # Configuration # Attributes': (c, next) ->
    attrs = c.conf.hbase.attributes
    attrs['hbase.rootdir'] = "#{c.conf.hadoop.attributes['fs.default.name']}/#{attrs['hbase.rootdir']}"
    attrs['hbase.log.dir'] = path.resolve c.conf.core.log, attrs['hbase.log.dir']
    files = ['hbase-site.xml', 'hbase-env.sh']
    files = for file in files
      options = 
        source: "#{__dirname}/../templates/#{c.conf.hbase.version}/#{file}"
        destination: "#{c.conf.hbase.conf}/#{file}"
        context: attrs
    mecano.render files, (err, rendered) ->
      next err, if rendered then recipe.OK else recipe.SKIPPED
  'HBase # Configuration # Directories': (c, next) ->
    mecano.mkdir
      directory: c.conf.hbase.attributes['hbase.log.dir']
    , (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED
  'HBase # Configuration # System': (c, next) ->
    next null, recipe.TODO
    ###
    1.  In the /etc/security/limits.conf file, add the following lines: 
      /etc/security/limits.conf
      hdfs  -     nofile  32768
      hbase  -     nofile  32768
    2.  To apply the changes in /etc/security/limits.conf on Ubuntu and other Debian systems, 
      add the following line in the /etc/pam.d/common-session file: 
      session required  pam_limits.so
    ###

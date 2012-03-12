
path = require 'path'
mecano = require 'mecano'
recipe = require '../../recipe'
properties = require '../lib/properties'

module.exports =
    attributes: recipe.wrap( 'Hadoop # Configuration # Attributes: ', (c, next) ->
        attrs = c.conf.hadoop.attributes
        # todo: use path.resolve, eg:
        # path.resolve c.conf.core.log, attrs['hbase.log.dir']
        attrs['hadoop.tmp.dir'] = path.resolve c.conf.core.var, attrs['hadoop.tmp.dir']
        attrs['dfs.name.dir'] = for dir in attrs['dfs.name.dir'] then path.resolve c.conf.core.var, dir
        attrs['dfs.data.dir'] = for dir in attrs['dfs.data.dir'] then path.resolve c.conf.core.var, dir
        attrs['mapred.local.dir'] = path.resolve c.conf.core.var, attrs['mapred.local.dir']
        attrs['mapred.system.dir'] = attrs['mapred.system.dir'] # it's an HDFS path
        files = ['core-site.xml', 'hdfs-site.xml', 'mapred-site.xml']
        files = for file in files
            options =
                source: "#{__dirname}/../templates/#{c.conf.hadoop.version}/#{file}"
                destination: "#{c.conf.hadoop.conf}/#{file}"
                context: attrs
        mecano.render files, (err, rendered) ->
            next err, if rendered then recipe.OK else recipe.SKIPPED
    )
    directories: recipe.wrap( 'Hadoop # Configuration # Directories: ', (c, next) ->
        file = "#{c.conf.hadoop.conf}/core-site.xml"
        properties.read file, 'hadoop.tmp.dir', (err, value) ->
            mecano.mkdir
                directory: value
                exclude: /\${/
            , (err, created) ->
                next err, if created then recipe.OK else recipe.SKIPPED
    )
        
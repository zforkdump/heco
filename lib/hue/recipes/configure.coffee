
fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
mecano = require 'mecano'
mysql = require 'mysql'
recipe = require '../../recipe'

module.exports = 
    attributes: recipe.wrap( 'Hue # Configuration # Attributes', (c, next) ->
        attrs = c.conf.hue.attributes
        attrs['hadoop.hadoop_home'] = c.conf.hadoop.prefix
        attrs['hadoop.hdfs_clusters.hdfs_port'] = c.conf.hadoop.attributes['fs.default.name'].split(':')[2]
        attrs['hadoop.hdfs_clusters.http_port'] = c.conf.hadoop.attributes['dfs.http.address'].split(':')[1]
        attrs['hdfs.thrift_port'] = c.conf.hadoop.attributes['dfs.thrift.address'].split(':')[1]
        attrs['mapred.thrift_port'] = c.conf.hadoop.attributes['jobtracker.thrift.address'].split(':')[1]
        attrs['hive_home_dir'] = c.conf.hive.prefix
        attrs['hive_conf_dir'] = c.conf.hive.conf
        mecano.render [
            source: "#{__dirname}/../templates/#{c.conf.hue.version}/hue.ini"
            destination: "#{c.conf.hue.prefix}/desktop/conf/hue.ini"
            context: attrs
        ,
            source: "#{__dirname}/../templates/#{c.conf.hue.version}/hue-beeswax.ini"
            destination: "#{c.conf.hue.prefix}/apps/beeswax/conf/hue-beeswax.ini"
            context: attrs
        ], (err, updated) ->
            next err, if updated then recipe.OK else recipe.SKIPPED
    )
    dirs: recipe.wrap( 'Hue # Configuration # Directories', (c, next) ->
        mecano.mkdir [
            directory: c.conf.hue.pid
            chmod: 0o0755
        ], (err, created) ->
            next err, if created then recipe.OK else recipe.SKIPPED
    )
    database: recipe.wrap( 'Hue # Configure # Database', (c, next) ->
        attrs = c.conf.hue.attributes
        connection_end = (callback) ->
            connection.end (err) ->
                callback err
        connection = mysql.createConnection
            host: attrs.database_host
            user: attrs.database_user
            password: attrs.database_password
        connection.query 'SHOW DATABASES;', (err, databases) ->
            return next err if err
            if (databases.filter (database) -> database.Database is 'hue').length
                return connection_end ->
                    next null, recipe.SKIPPED
            connection.query 'CREATE DATABASE `hue`;', (err, result) ->
                connection_end ->
                    next err, recipe.OK
    )
    # TODO: Build only if configuration has changed to reflect changes in database settings
    # Among the created file: './app.reg'
    build: recipe.wrap( 'Hue # Configure # Build', (c, next) ->
        mecano.exec
            cmd: 'export CC=gcc && make apps'
            cwd: c.conf.hue.prefix
            not_if_exists: "#{c.conf.hue.prefix}/app.reg"
        , (err, executed, stdout, stderr) ->
            next err, if executed then recipe.OK else recipe.SKIPPED
    )
                

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
mecano = require 'mecano'
mysql = require 'mysql'

module.exports = 
    attributes: (req, res, next) ->
        res.blue 'Hue # Configuration # Attributes: '
        c = req.hmgr.config
        #questions = c.hue.attributes
        #req.question questions, (attrs) ->
        attrs = c.hue.attributes
        attrs['hadoop.hadoop_home'] = c.hadoop.prefix
        attrs['hadoop.hdfs_clusters.hdfs_port'] = c.hadoop.attributes['fs.default.name'].split(':')[2]
        attrs['hadoop.hdfs_clusters.http_port'] = c.hadoop.attributes['dfs.http.address'].split(':')[1]
        attrs['hdfs.thrift_port'] = c.hadoop.attributes['dfs.thrift.address'].split(':')[1]
        attrs['mapred.thrift_port'] = c.hadoop.attributes['jobtracker.thrift.address'].split(':')[1]
        attrs['hive_home_dir'] = c.hive.prefix
        attrs['hive_conf_dir'] = c.hive.conf
        mecano.render [
            source: "#{__dirname}/../templates/#{c.hue.version}/hue.ini"
            destination: "#{c.hue.prefix}/desktop/conf/hue.ini"
            context: attrs
        ,
            source: "#{__dirname}/../templates/#{c.hue.version}/hue-beeswax.ini"
            destination: "#{c.hue.prefix}/apps/beeswax/conf/hue-beeswax.ini"
            context: attrs
        ], (err, updated) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if updated then 'OK' else 'SKIPPED').ln()
            next()
    dirs: (req, res, next) ->
        res.blue 'Hue # Configuration # Directories: '
        c = req.hmgr.config
        mecano.mkdir [
            directory: c.hue.pid
            chmod: 0755
        ], (err, created) ->
            return res.cyan('FAILED').ln() && next err if err
            res.cyan(if created then 'OK' else 'SKIPPED').ln()
            next()
    database: (req, res, next) ->
        res.blue 'Hue # Configure # Database: '
        c = req.hmgr.config
        attrs = c.hue.attributes
        client_end = (callback) ->
            client.end (err) ->
                return res.red('FAILED').ln() && next err if err
                callback()
        client = mysql.createClient
            host: attrs.database_host
            user: attrs.database_user
            password: attrs.database_password
        client.query 'SHOW DATABASES;', (err, databases) ->
            if (databases.filter (database) -> database.Database is 'hue').length
                return client_end ->
                    res.cyan('SKIPPED').ln() && next()
            client.query 'CREATE DATABASE `hue`;', (err, result) ->
                client_end ->
                    return res.red('FAILED').ln() && next err if err
                    res.cyan('OK').ln()
                    next()
    # TODO: Build only if configuration has changed to reflect changes in database settings
    build: (req, res, next) ->
        res.blue 'Hue # Configure # Build: '
        c = req.hmgr.config
        return res.cyan('CACHE').ln() && next() if c.hue.extracted is 'CACHE'
        cmd = exec "cd #{c.hue.prefix} && make apps" #, cwd: c.hue.prefix
        cmd.stdout.on 'data', (data) ->
            #res.blue data
        cmd.stderr.on 'data', (data) ->
            #res.magenta data
        cmd.on 'exit', (code) ->
            # Full build return a code equals to null, strange
            return res.red('FAILED').ln() && next new Error "Failed to build Hue with code #{code}" unless code is null or code is 0
            res.cyan('OK').ln()
            next()
                
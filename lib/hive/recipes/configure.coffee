
path = require 'path'
fs = require 'fs'
mysql = require 'mysql'
exec = require('child_process').exec
mecano = require 'mecano'
recipe = require '../../recipe'
properties = require '../../hadoop/lib/properties'

module.exports = 
    check: recipe.wrap( 'Hive # Configuration # Check', (c, next) ->
        # Make sure hadoop build is not present other hive throw JDOFatalInternalException
        path.exists "#{c.conf.hadoop.prefix}/build", (exists) ->
            err = new Error 'Hadoop build directory shall disappear' if exists
            next err, recipe.OK
    )
    attributes: recipe.wrap( 'Hive # Configuration # Attributes', (c, next) ->
        attrs = c.conf.hive.attributes
        attrs['hive.exec.scratchdir'] = path.resolve c.conf.core.tmp, attrs['hive.exec.scratchdir']
        attrs['hive.log.direxec'] = path.resolve c.conf.core.log, attrs['hive.log.direxec']
        attrs['hive.log.dir'] = path.resolve c.conf.core.log, attrs['hive.log.dir']
        attrs['hadoop_home'] = c.conf.hadoop.prefix
        attrs['hive.metastore.local'] = 'true' #todo
        switch attrs.database_engine
            when 'mysql'
                # attrs['hive.metastore.local'] = 'false' #todo
                protocol = "jdbc:#{attrs.database_engine}"
                host = attrs.database_host
                username = attrs.database_username
                password = attrs.database_password
                driver = attrs.database_driver
                create = "createDatabaseIfNotExist=#{if attrs.database_create then 'yes' else ''}"
                # service
                db = attrs.database_name
                attrs['javax.jdo.option.ConnectionUserName'] ?= username
                attrs['javax.jdo.option.ConnectionPassword'] ?= password
                attrs['javax.jdo.option.ConnectionDriverName'] ?= attrs.database_driver
                attrs['javax.jdo.option.ConnectionURL'] ?= "#{protocol}://#{host}:#{attrs.database_port}/#{db}?#{create}"
                # Stats
                db = attrs.stats_database_name
                params = "?user=#{username}"
                params += "&amp;password=#{password}" if password
                params += "&amp;#{create}"
                attrs['hive.stats.dbclass'] ?= 'jdbc:mysql'
                attrs['hive.stats.jdbcdriver'] ?= attrs.database_driver
                attrs['hive.stats.dbconnectionstring'] ?= 
                    "#{protocol}://#{host}/#{db}#{params}"
        files = ['hive-env.sh', 'hive-site.xml', 'hive-log4j.properties', 'hive-exec-log4j.properties']
        files = for file in files
            {
                source: "#{__dirname}/../templates/#{c.conf.hive.version}/#{file}"
                destination: "#{c.conf.hive.conf}/#{file}"
                context: attrs
            }
        mecano.render files, (err, rendered) ->
            return next err if err
            fixpwpath = "#{c.conf.hive.conf}/hive-default.xml"
            fs.readFile fixpwpath, 'ascii', (err, content) ->
                content = content.replace /mine/, ''
                fs.writeFile fixpwpath, content, (err) ->
                    next err, if rendered then recipe.OK else recipe.SKIPPED
    )
    dirs: recipe.wrap( 'Hive # Configuration # Directories', (c, next) ->
        mecano.mkdir
            directory: path.dirname c.conf.hive.pid
            chmod: 0o0755
        , (err, created) ->
            next err, if created then recipe.OK else recipe.SKIPPED
    )
    database: recipe.wrap( 'Hive # Configure # Database', (c, next) ->
        # Hive will complain on schema creation if encoding isnt latin1
        # because it try to insert some very large keys
        # such a good dump java citizen
        #     DROP DATABASE hive;
        #     CREATE DATABASE hive CHARACTER SET latin1 COLLATE latin1_general_ci
        # and of course, thats not enough, down the read there was other problems
        # But wait, there is always a solution:
        # downgrade to mysql server <= 5.1.58
        # TODO: check mysql version, create db & user
        attrs = c.conf.hive.attributes
        client = null
        databases = null
        created = 0
        connect = () ->
            client = mysql.createClient
                host: attrs.database_host
                user: attrs.database_username
                password: attrs.database_password
            list()
        list = () ->
            client.query 'SHOW DATABASES;', (err, dbs) ->
                return close err if err
                databases = dbs
                metastore()
        metastore = () ->
            if (databases.filter (database) -> database.Database is attrs.database_name).length
                return stats()
            client.query "CREATE DATABASE `#{attrs.database_name}`;", (err, result) ->
                return close err if err
                created++
                stats()
        stats = () ->
            if (databases.filter (database) -> database.Database is attrs.stats_database_name).length
                return close()
            client.query "CREATE DATABASE `#{attrs.stats_database_name}`;", (err, result) ->
                return close err if err
                created++
                close()
        close = (e) ->
            client.end (err) ->
                if created is 2 then code = recipe.OK
                else if created is 1 then code = recipe.PARTIAL
                else code = recipe.SKIPPED
                next err, code
        connect()
    )
    hdfs: recipe.wrap( 'Hive # Configure # HDFS', (c, next) ->
        return next null, recipe.TODO
        # Extract namenode hostname and port
        properties.read "#{c.conf.hadoop.conf}/core-site.xml", 'fs.default.name', (err, value) ->
            return res.red('FAILED').ln() and next err if err
            [_, host, port] = /:\/\/(.+):(\d+)\/?$/.exec(value)
            # Make sure hdfs is running
            mecano.isPortOpen port, host, (err, open) ->
                return res.red('FAILED').ln() and next err if err
                return res.red('FAILED').ln() and next new Error 'Failed to create Hive directory, Hadoop not started' unless open
                exec "#{c.conf.hadoop.bin}/hadoop fs -test -e #{hive.metastore.warehouse.dir}", (err, stdout, stderr) ->
                    return res.cyan('SKIPPED').ln() unless err
                    return res.red('FAILED').ln() and next err if err and err.code isnt 1
                    exec "#{c.conf.hadoop.bin}/hadoop fs -mkdir #{hive.metastore.warehouse.dir}", (err) ->
                        next err, recipe.OK
    )
        
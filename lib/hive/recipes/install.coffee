
path = require 'path'
fs = require 'fs'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        res.blue 'Hive # Install # Download: '
        c = req.hmgr.config
        mecano.download
            source: c.hive.source
            destination: "#{c.core.tmp}/#{path.basename c.hive.source}"
            force: false
        , (err, downloaded) ->
            return res.red('FAILED').ln() and next err if err
            res.cyan(if downloaded then 'OK' else 'CACHE').ln()
            next()
    download_driver: (req, res, next) ->
        res.blue 'Hive # Install # Download MySQL driver: '
        c = req.hmgr.config
        name = /\/([\w\d-\.]+.tar.gz)/.exec(c.hive.attributes.database_driver_url)[1]
        mecano.download
            source: c.hive.attributes.database_driver_url
            destination: "#{c.core.tmp}/#{name}"
        , (err, downloaded) ->
            return res.red('FAILED').ln() and next err if err
            res.cyan(if downloaded then 'OK' else 'CACHE').ln()
            next()
    extract: (req, res, next) ->
        res.blue 'Hive # Install # Extract: '
        c = req.hmgr.config
        mecano.extract
            source: "#{c.core.tmp}/#{path.basename c.hive.source}"
            destination: c.core.lib
            not_if_exists: "#{c.core.lib}/#{path.basename c.hive.source, '.tar.gz'}"
        , (err, extracted) ->
            return res.red('FAILED').ln() and next err if err
            res.cyan(if extracted then 'OK' else 'CACHE').ln()
            next()
    extract_driver: (req, res, next) ->
        res.blue 'Hive # Install # Extract MySQL driver: '
        c = req.hmgr.config
        name = /\/([\w\d-\.]+.tar.gz)/.exec(c.hive.attributes.database_driver_url)[1]
        mecano.extract
            source: "#{c.core.tmp}/#{name}"
            destination: c.core.tmp
            not_if_exists: "#{c.hive.lib}/#{path.basename name, '.tar.gz'}-bin.jar"
        , (err, extracted) ->
            return res.red('FAILED').ln() and next err if err
            return res.cyan('SKIPPED').ln() and next() unless extracted
            fs.rename "#{c.core.tmp}/#{path.basename name, '.tar.gz'}/#{path.basename name, '.tar.gz'}-bin.jar", "#{c.hive.lib}/#{path.basename name, '.tar.gz'}-bin.jar", (err) ->
                mecano.rm "#{c.core.tmp}/#{path.basename name, '.tar.gz'}", (err, removed) ->
                    return res.red('FAILED').ln() and next err if err or not removed
                    res.cyan('OK').ln()
                    next()

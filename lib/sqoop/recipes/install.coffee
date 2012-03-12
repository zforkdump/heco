
fs = require 'fs'
path = require 'path'
config = require '../../lib/config'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        config (config) ->
            res.blue 'Downloading Sqoop: '
            source = config.sqoop_source
            tmp = config.core.tmp
            destination = "#{tmp}/#{path.basename source}"
            mecano.download
                source: source
                destination: destination
                force: false
            , (err, downloaded) ->
                return next err if err
                message = if downloaded then 'OK' else 'CACHE'
                res.cyan(message).ln()
                next()
    extract: (req, res, next) ->
        config (config) ->
            res.blue 'Extracting Sqoop: '
            tmp = config.core.tmp
            source = "#{tmp}/#{path.basename config.sqoop_source}"
            mecano.extract
                source: source
                destination: config.core.data
                not_if_exists: "#{config.core.data}/#{path.basename source, '.tar.gz'}"
            , (err, extracted) ->
                return next err if err
                message = if extracted then 'OK' else 'CACHE'
                res.cyan(message).ln()
                next()

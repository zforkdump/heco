
path = require 'path'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        res.blue "Oozie # Install # Download: "
        c = req.hmgr.config
        mecano.download
            source: c.oozie.source
            destination: "#{c.core.tmp}/#{path.basename c.oozie.source}"
            force: false
        , (err, downloaded) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if downloaded then 'OK' else 'CACHE').ln()
            next()
    extract: (req, res, next) ->
        res.blue 'Oozie # Install # Extract: '
        c = req.hmgr.config
        mecano.extract
            source: "#{c.core.tmp}/#{path.basename c.oozie.source}"
            destination: c.core.lib
            not_if_exists: "#{c.core.lib}/#{path.basename c.oozie.source, '.tar.gz'}"
        , (err, extracted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if extracted then 'OK' else 'CACHE').ln()
            next()

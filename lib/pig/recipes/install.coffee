
path = require 'path'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        res.blue "Pig # Install # Download: "
        c = req.hmgr.config
        mecano.download
            source: c.pig.source
            destination: "#{c.core.tmp}/#{path.basename c.pig.source}"
            force: false
        , (err, downloaded) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if downloaded then 'OK' else 'CACHE').ln()
            next()
    extract: (req, res, next) ->
        res.blue 'Pig # Install # Extract: '
        c = req.hmgr.config
        mecano.extract
            source: "#{c.core.tmp}/#{path.basename c.pig.source}"
            destination: c.core.lib
            not_if_exists: "#{c.core.lib}/#{path.basename c.pig.source, '.tar.gz'}"
        , (err, extracted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if extracted then 'OK' else 'CACHE').ln()
            next()

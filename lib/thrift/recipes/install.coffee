
path = require 'path'
mecano = require 'mecano'

module.exports =
    download: (req, res, next) ->
        res.blue "Thrift # Install # Download: "
        c = req.hmgr.config
        mecano.download
            source: c.thrift.source
            destination: "#{c.core.tmp}/#{path.basename c.thrift.source}"
            force: false
        , (err, downloaded) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if downloaded then 'OK' else 'CACHE').ln()
            next()
    extract: (req, res, next) ->
        res.blue 'Thrift # Install # Extract: '
        c = req.hmgr.config
        mecano.extract
            source: "#{c.core.tmp}/#{path.basename c.thrift.source}"
            destination: c.core.tmp
            not_if_exists: "#{c.core.tmp}/#{path.basename c.thrift.source, '.tar.gz'}"
        , (err, extracted) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if extracted then 'OK' else 'CACHE').ln()
            next()
    build: (req, res, next) ->
        res.blue 'Thrift # Install # Build: '
        c = req.hmgr.config
        mecano.exec 
            cmd: [
                'chmod u+x install-sh'
                'chmod u+x configure'
                "./configure --prefix=#{c.thrift.prefix} --without-python --without-php"
                'make'
                'make install'
            ].join(' && ')
            cwd: "#{c.core.tmp}/#{path.basename c.thrift.source, '.tar.gz'}"
            not_if_exists: c.thrift.prefix
        , (err, executed) ->
            return res.red('FAILED').ln() && next err if err
            res.cyan(if executed then 'OK' else 'CACHE').ln()
            next()

mecano = require 'mecano'

module.exports = (req, res, next) ->
    return next()
    res.blue 'Java # Apt-get: '
    mecano.render
        content: 'deb http://archive.canonical.com/ubuntu maverick partner'
        destination: '/etc/apt/sources.list.d/ubuntu_partner.list'
    , (err, modified) ->
        return res.red('FAILED').ln() if err
        res.cyan(if modified then 'OK' else 'SKIPPED').ln() and next()
        

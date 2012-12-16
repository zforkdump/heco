
mecano = require 'mecano'

module.exports = 
  'Flume # Configuration # Attributes': (c, next) ->
    files = for file in ['flume-site.xml']
      options =
        source: "#{__dirname}/../templates/#{c.conf.flume.version}/#{file}"
        destination: "#{c.conf.flume.conf}/#{file}"
        context: c.conf.flume.attributes
    mecano.render files, (err, rendered) ->
      next err, if rendered then 'OK' else 'SKIPPED'
  'Flume # Configuration # Environment': (c, next) ->
    attrs = 
      'FLUME_HOME': c.conf.flume.prefix
      'FLUME_LOG_DIR': c.conf.flume.log
      'FLUME_PID_DIR': c.conf.flume.pid
    mecano.render 
      source: "#{__dirname}/../templates/#{c.conf.flume.version}/flume-env.sh"
    , (err, rendered) ->
      next err, if rendered then 'OK' else 'SKIPPED'

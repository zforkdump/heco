
mecano = require 'mecano'

module.exports = 
  'HBase # Activation # Bin': (c, next) ->
    files = [
      'graceful_stop.sh', 'hbase-config.sh', 'hbase-daemon.sh', 
      'hbase-daemons.sh', 'local-master-backup.sh', 
      'local-regionservers.sh', 'master-backup.sh', 'regionservers.sh', 
      'rolling-restart.sh', 'start-hbase.sh', 'stop-hbase.sh'
    ]
    files = for file in files then "#{c.conf.core.bin}/#{file}"
    mecano.rm files, (err, deleted) ->
      next err, if deleted then 'OK' else 'SKIPPED'
  'HBase # Desactivation # Conf': (c, next) ->
    mecano.rm "#{c.conf.core.etc}/hbase", (err, deleted) ->
      next err, if deleted then 'OK' else 'SKIPPED'
  'HBase # Desactivation # Log': (c, next) ->
    mecano.rm "#{c.conf.core.log}/hbase", (err, deleted) ->
      next err, if deleted then 'OK' else 'SKIPPED'

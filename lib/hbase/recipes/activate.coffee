
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports =
  'HBase # Activation # Bin': (c, next) ->
    files = [
      'graceful_stop.sh', 'hbase', 'hbase-config.sh', 'hbase-daemon.sh', 
      'hbase-daemons.sh', 'local-master-backup.sh', 
      'local-regionservers.sh', 'master-backup.sh', 'regionservers.sh', 
      'rolling-restart.sh', 'start-hbase.sh', 'stop-hbase.sh'
    ]
    links = for file in files
      options = 
        source: "#{c.conf.hbase.bin}/#{file}"
        destination: "#{c.conf.core.bin}/#{file}"
        exec: true
        chmod: 0o0755
    mecano.link links, (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED
  'HBase # Activation # Conf': (c, next) ->
    mecano.link
      source: c.conf.hbase.conf
      destination: "#{c.conf.core.etc}/hbase"
    , (err, created) ->
      next err, if created then recipe.OK else recipe.SKIPPED
  # 'HBase # Activation # Log': (c, next) ->
  #   mecano.link
  #     source: c.conf.hbase.log
  #     destination: "#{c.conf.core.log}/hbase"
  #   , (err, created) ->
  #     next err, if created then recipe.OK else recipe.SKIPPED

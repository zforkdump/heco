
fs = require 'fs'
path = require 'path'
glob = require 'glob'
mecano = require 'mecano'
recipe = require '../../recipe'

module.exports = 
  bin: recipe.wrap( 'Hue # Activation # Bin', (c, next) ->
    mecano.link
      source: "#{c.conf.hue.prefix}/build/env/bin/supervisor"
      destination: "#{c.conf.core.bin}/hue"
      exec: true
      chmod: 0o0755
    , (err, linked) ->
      next err, if linked then recipe.OK else recipe.SKIPPED
  )
  jars: recipe.wrap( 'Hue # Activate # Hadoop jars', (c, next) ->
    glob "#{c.conf.hue.prefix}/desktop/libs/hadoop/java-lib/hue*jar", (err, jars) ->
      jars = for jar in jars
        { source: jar, destination: "#{c.conf.hadoop.prefix}/lib/#{path.basename jar}" }
      mecano.link jars, (err, linked) ->
        next err, if linked then recipe.OK else recipe.SKIPPED
  )
  conf: recipe.wrap( 'Hue # Activation # Conf', (c, next) ->
    mecano.link [
      source: "#{c.conf.hue.prefix}/desktop/conf/hue.ini"
      destination: "#{c.conf.core.etc}/hue/hue.ini"
    ,
      source: "#{c.conf.hue.prefix}/apps/beeswax/conf/hue-beeswax.ini"
      destination: "#{c.conf.core.etc}/hue/hue-beeswax.ini"
    ], (err, linked) ->
      next err, if linked then recipe.OK else recipe.SKIPPED
  )

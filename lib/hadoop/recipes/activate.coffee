
path = require 'path'
fs = require 'fs'
exec = require('child_process').exec
glob = require 'glob'
mecano = require 'mecano'
properties = require '../lib/properties'
recipe = require '../../recipe'

module.exports = 
  bin: recipe.wrap( 'Hadoop # Activation # Bin', (c, next) ->
    glob "#{c.conf.hadoop.bin}/*", (err, files) ->
      files = for file in files
        options = 
          source: file
          destination: "#{c.conf.core.bin}/#{path.basename file}"
          exec: true
      mecano.link files, (err, linked) ->
        next err, if linked then recipe.OK else recipe.SKIPPED
  )
  conf: recipe.wrap( 'Hadoop # Activation # Conf', (c, next) ->
    mecano.link
      source: c.conf.hadoop.conf
      destination: "#{c.conf.core.etc}/hadoop"
    , (err, created) ->
      next err, if created then 'OK' else 'SKIPPED'
  )
  log: recipe.wrap( 'Hadoop # Activation # Log', (c, next) ->
    mecano.mkdir c.conf.hadoop.logs, (err, created) ->
      mecano.link
        source: c.conf.hadoop.logs
        destination: "#{c.conf.core.log}/hadoop"
      , (err, created) ->
        next err, if created then recipe.OK else recipe.SKIPPED
  )
  format: recipe.wrap( 'Hadoop # Activation # Format Namenode', (c, next) ->
    properties.read "#{c.conf.hadoop.conf}/hdfs-site.xml", 'dfs.name.dir', (err, dfs_name_dir) ->
      return next err if err
      # -i      The -i (simulate initial login) option runs the shell specified in the passwd(5) entry of the target user as a login shell.
      # -S      The -S (stdin) option causes sudo to read the password from the standard input instead of the terminal device.
      # -s [command]  The -s (shell) option runs the shell specified by the SHELL environment variable if it is set or the shell as specified in passwd(5).
      # -n      The -n (non-interactive) option prevents sudo from prompting the user for a password.
      #c = "sudo -s /bin/bash -u #{hdfsUser} yes 'Y' | ./hadoop namenode -format ; true"
      #c = """
      #/bin/sh -c "sudo -u #{hdfsUser} yes 'Y' | ./hadoop namenode -format ; true"
      #"""
      mecano.exec
        cmd: "sudo -u #{c.conf.hadoop.hdfs_user} ./hadoop namenode -format"
        cwd: "#{c.conf.hadoop.bin}"
        not_if_exists: dfs_name_dir
      , (err, executed, stdout, stderr) ->
        next err, if executed then recipe.OK else recipe.SKIPPED
  )

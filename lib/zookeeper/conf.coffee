
module.exports = zookeeper:
  version: '3.3.4-cdh3u3'
  source: 'http://archive.cloudera.com/cdh4/cdh/4/zookeeper-3.4.3-cdh4.1.2.tar.gz'
  attributes:
    tickTime: 2000
    initLimit: 10
    syncLimit: 5
    dataDir: './var/zookeeper'
    clientPort: 2181
    'zookeeper.log.dir': './zookeeper'

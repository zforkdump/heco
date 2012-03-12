
module.exports = zookeeper:
    version: '3.3.4-cdh3u3'
    attributes:
        tickTime: 2000
        initLimit: 10
        syncLimit: 5
        dataDir: './var/zookeeper'
        clientPort: 2181
        # logs
        'zookeeper.log.dir': './zookeeper'

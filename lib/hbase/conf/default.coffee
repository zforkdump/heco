
module.exports = hbase:
    version: '0.90.4-cdh3u3'
    attributes: 
        'dfs.datanode.max.xcievers': 4096
        'hbase.cluster.distributed': true # Pseudo-distributed Mode
        # Be sure to replace localhost with the host name of your HDFS Name Node if it is not running locally.
        # Will be replace as 
        # #{hadoop.fs.default.name}/#{hbase.rootdir}
        # eg: hdfs://localhost:8020/hbase
        'hbase.rootdir': 'hbase' # Pseudo-distributed Mode
        # Test HBase with high data durability enabled
        'dfs.support.append': true
        # Property from ZooKeeper's config zoo.cfg. The port at which the clients will connect. 
        'hbase.zookeeper.property.clientPort': 2181
        # Property from ZooKeeper's config zoo.cfg. Limit on number of concurrent connections (at the socket level) that a single client, identified by IP address, may make to a single member of the ZooKeeper ensemble. Set high to avoid zk connection issues running standalone and pseudo-distributed. 
        'hbase.zookeeper.property.maxClientCnxns': 30
        # Port used by ZooKeeper peers to talk to each other. 
        # See http://hadoop.apache.org/zookeeper/docs/r3.1.1/zookeeperStarted.html#sc_RunningReplicatedZooKeeper for more information. 
        'hbase.zookeeper.peerport': 2888
        'hbase.zookeeper.leaderport': 3888
        'hbase.log.dir': './hbase'

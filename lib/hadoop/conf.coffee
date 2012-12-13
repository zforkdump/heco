
os = require 'os'
cpus_num = os.cpus().length

module.exports = hadoop:
  version: '0.20.2-cdh3u3'
  source: 'http://archive.cloudera.com/cdh4/cdh/4/hadoop-2.0.0-cdh4.1.2.tar.gz'
  hdfs_user: process.env.USER
  mapred_user: process.env.USER
  attributes:
    'fs.default.name': 'hdfs://localhost:8020'
    'dfs.secondary.http.address': '0.0.0.0:50090'
    'dfs.name.dir': ['./hadoop/nn'] # Relative to `core.var`, could be on per disk partition
    'dfs.data.dir': ['./hadoop/dd'] # Relative to `core.var`, could be on per disk partition
    'dfs.block.size': 67108864 #64Mo
    'dfs.namenode.handler.count': cpus_num * 2
    'dfs.http.address': '0.0.0.0:50070'
    'dfs.datanode.max.xcievers': 4096 # Default is 256
    'dfs.replication': 3
    'dfs.namenode.plugins': 'org.apache.hadoop.thriftfs.NamenodePlugin'
    'dfs.datanode.plugins': 'org.apache.hadoop.thriftfs.DatanodePlugin'
    'dfs.thrift.address': '0.0.0.0:10090'
    'mapred.job.tracker': 'hdfs://localhost:8021'
    # A base for other temporary directories.
    # Default is `/tmp/hadoop-${user.name}`
    'hadoop.tmp.dir': './hadoop/cache/${user.name}' # Relative to `core.var`
    # An array
    # Usually one per disk
    'mapred.local.dir': './hadoop/mapred/local' # Relative to `core.var`
    'mapred.system.dir': '/mapred/system' # HDFS folder
    'mapred.job.tracker.handler.count': cpus_num * 2
    'mapred.tasktracker.map.tasks.maximum': cpus_num * 2
    'mapred.tasktracker.reduce.tasks.maximum': cpus_num * 2
    # Node, Cloudera cluster setup realworl exemple mention 20
    'mapred.reduce.parallel.copies': 20
    'mapred.map.child.java.opts': '-Xmx512M'
    'mapred.reduce.child.java.opts': '-Xmx512M'
    'fs.inmemory.size.mb': 200
    'io.sort.factor': 100
    'io.sort.mb': 200
    # Read/write buffer size used in SequenceFiles (should be in multiples of the hardware page size)
    # Yahoo recommend 32768-131072
    # see http://developer.yahoo.com/hadoop/tutorial/module7.html#config-large
    'io.file.buffer.size': 131072
    'mapred.task.tracker.task-controller': 'org.apache.hadoop.mapred.DefaultTaskController'
    'mapred.tasktracker.dns.interface': 'default'
    'mapred.tasktracker.dns.nameserver': 'default'
    'jobtracker.thrift.address': '0.0.0.0:9290'
    # An array
    # Comma-separated list of jobtracker plug-ins to be activated.
    'mapred.jobtracker.plugins': 'org.apache.hadoop.thriftfs.ThriftJobTrackerPlugin'

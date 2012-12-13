
module.exports = sqoop:
  version: '1.3.0-cdh3u3'
  source: 'http://archive.cloudera.com/cdh4/cdh/4/sqoop-1.4.1-cdh4.1.2.tar.gz'
  attributes:
    ###
    A comma-delimited list of ManagerFactory implementations
    which are consulted, in order, to instantiate ConnManager instances
    used to drive connections to databases.
    choices: ['true', 'false']
    ###
    'sqoop.connection.factories': 'true'
    ###
    A comma-delimited list of ToolPlugin implementations
    which are consulted, in order, to register SqoopTool instances which
    allow third-party tools to be used.
    ###
    'sqoop.tool.plugins': ''
    'sqoop.metastore.client.enable.autoconnect': 'false'
    'sqoop.metastore.client.autoconnect.url': 'jdbc:hsqldb:file:/tmp/sqoop-meta/meta.db;shutdown=true'
    'sqoop.metastore.client.autoconnect.username': 'SA'
    'sqoop.metastore.client.autoconnect.password': ''
    'sqoop.metastore.client.record.password': 'true'
    'sqoop.metastore.server.location': '/tmp/sqoop-metastore/shared.db'
    'sqoop.metastore.server.port': '16000'

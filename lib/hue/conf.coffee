
module.exports = hue:
  version: '1.2.0.0-cdh3u3'
  source: 'http://archive.cloudera.com/cdh4/cdh/4/hue-2.1.0-cdh4.1.2.tar.gz'
  attributes:
    'secret_key': ''
    'http_host': '0.0.0.0'
    'http_port': 8088
    'database_engine': 'mysql'
    'database_host': 'localhost'
    'database_port': '3306'
    'database_user': 'root'
    'database_password': ''
    'database_name': 'hue'
    'smtp_host': ''
    'smtp_port': 25
    'smtp_user': ''
    'smtp_password': ''
    'tls': 'no' #one_of: ['yes', 'no']
    'default_from_email': 'hue@localhost'

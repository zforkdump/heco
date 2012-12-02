
module.exports = hue:
  version: '1.2.0.0-cdh3u3'
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

import os

# Load default config generated by pgAdmin
from pgadmin.settings import *

# SSL Configuration
DEFAULT_SERVER = '172.30.0.150'
DEFAULT_SERVER_PORT = 3100
SERVER_MODE = True
SECURE_PROXY_SSL_HEADER = ('X-Forwarded-Proto', 'https')
SSL_CERTIFICATE = os.getenv('SSL_CERTIFICATE', '/certs/fullchain.pem')
SSL_KEY = os.getenv('SSL_KEY', '/certs/privkey.pem')

default['postgresql']['password']['postgres'] = '50ce1017bb2e1ec822fbe3eea2cfad1d'

default['postgresql']['database'] = "site_production"
default['postgresql']['user']['name'] = "misciadotnet"
default['postgresql']['user']['password'] = "m1sc1a"

default['postgresql']['pg_hba'] = [
  { type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'trust' },
  { type: 'local', db: 'all', user: 'misciadotnet', addr: nil, method: 'md5' },
  { type: 'host', db: 'site_production', user: 'misciadotnet', addr: '0.0.0.0/0', method: 'md5' }
]
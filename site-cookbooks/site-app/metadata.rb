name             'site-app'
maintainer       'Kevin Miscia'
maintainer_email 'kmiscia@miscia.net'
license          'All rights reserved'
description      'Gets the site app from github and deploys it'
version          '0.1.0'

# The sphinx cookbook relies on the mysql cookbook having
# a recipe called 'mysql::client'. Version 5.6.3 is the latest
# version that has that (has been removed from recent versions)
depends 'mysql'
depends 'sphinx'

depends 'rails'
depends 'passenger_apache2'
depends 'imagemagick'
depends 'resque'
depends 'redis'

# Some dependency requires V8 and doesn't install it?
# Just install it for now...
depends 'nodejs'
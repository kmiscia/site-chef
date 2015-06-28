name             'site-app'
maintainer       'Kevin Miscia'
maintainer_email 'kmiscia@miscia.net'
license          'All rights reserved'
description      'Gets the site app from github and deploys it'
version          '0.1.0'

depends 'rails'
depends 'passenger_apache2'
depends 'imagemagick'

# Some dependency/process requires a JS engine to 
# be installed. Just install nodejs for now. There
# may be lighter solutions than including all of nodejs
depends 'nodejs'
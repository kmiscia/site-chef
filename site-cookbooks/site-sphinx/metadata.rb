name             'site-sphinx'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures site-sphinx'
long_description 'Installs/Configures site-sphinx'
version          '0.1.0'

# The sphinx cookbook relies on the mysql cookbook having
# a recipe called 'mysql::client'. Version 5.6.3 is the latest
# version that has that (has been removed from recent versions)
depends 'mysql'
depends 'sphinx'
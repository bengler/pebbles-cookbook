name             "pebbles"
maintainer       "Lars Haugseth"
maintainer_email "lars.haugseth@amedia.no"
license          "All rights reserved"
description      "Installs/Configures Pebblestack and its components"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

depends "rvm"
depends "nginx"
depends "haproxy", "< 1.3.0"
depends "postgresql"

#!bin/bash
set -e

# Takes one argument: <sitename>.<env>

site=$1
sitename=${site%%.*}
environment=${site##*.}

connection_info=($(terminus connection:info --fields='MySQL Host,MySQL Password,MySQL Port' --format='list' $sitename.$environment))
connection_info+=($(terminus env:info --field='Domain' --format='string' $sitename.$environment))

host=${connection_info[0]}
password=${connection_info[1]}
port=${connection_info[2]}
url=${connection_info[3]}


dbhostafterdbserver=`echo $host | cut -d '.' -f 3-5`
hostwithoutdrush=`echo $dbhostafterdbserver | cut -d '.' -f 1`
echo "<?php
\$aliases['$sitename.$environment'] = array(
  'uri' => '$url',
  'db-url' => 'mysql://pantheon:$password@$host:$port/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.$environment.$dbhostafterdbserver',
  'remote-user' => '$environment.$hostwithoutdrush',
  'ssh-options' => '-p 2222 -o \"AddressFamily inet\"',
  'path-aliases' => array(
    '%files' => 'code/sites/default/files',
    '%drush-script' => 'drush',
   ),
);" > $environment-$sitename.aliases.drushrc.php

echo "Alias file $environment-$sitename.aliases.drushrc.php created"
drush cc drush

# Checking if the directory ~/.drush/aliases exists
# Create the directory if it does not
if [ ! -d "/Users/$(whoami)/.drush/aliases" ]; then
  mkdir ~/.drush/aliases
fi

# Move the alias file into ~/.drush/aliases folder. 
mv $environment-$sitename.aliases.drushrc.php ~/.drush/aliases

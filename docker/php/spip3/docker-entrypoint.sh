#!/bin/bash
set -e

run_as() {
	if [ "$(id -u)" = 0 ]; then
		su -p www-data -s /bin/sh -c "$1"
	else
		sh -c "$1"
	fi
}

installed_version="0.0.0"
if [ -f "/var/www/html/ecrire/inc_version.php" ]; then
	installed_version=$(grep -i /var/www/html/ecrire/inc_version.php  -e '\$spip_version_branche =' | cut -d '=' -f 2 | cut -d ';' -f 1 | cut -d "'" -f 2 | cut -d '"' -f 2)
fi

echo $installed_version
echo >&2 "Create plugins, libraries and template directories"
mkdir -p plugins/auto
mkdir -p lib
mkdir -p local
mkdir -p squelettes
mkdir -p tmp/{dump,log,upload}
chown -R www-data:www-data plugins lib squelettes tmp local

exec "$@"
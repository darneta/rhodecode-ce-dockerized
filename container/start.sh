if [ ! -f .rcinstalled ]; then
	echo "RC not installed. Running install scripts...\n"
	
	echo "Installing VCSServer...\n"
	.rccontrol-profile/bin/rccontrol install VCSServer --accept-license '{"host":"127.0.0.1", "port":10005}' --version 4.6.1 --offline

	echo "Installing RC Community edition...\n"
	.rccontrol-profile/bin/rccontrol install --accept-license Community  '{"host":"0.0.0.0", "port":10008, "username":"admin", "password":"secret", "email":"support@rhodecode.com", "repo_dir":"/home/rhodecode/repo", "database": "mysql://rhodecode:rhodecode@db/rhodecode"}' --version 4.6.1 --offline

	touch .rccontrol/supervisor/rhodecode_config_supervisord.ini
	echo "[supervisord]" >> .rccontrol/supervisor/rhodecode_config_supervisord.ini
	echo "nodaemon = true" >> .rccontrol/supervisor/rhodecode_config_supervisord.ini
	
	.rccontrol-profile/bin/rccontrol self-stop

    touch .rcinstalled
fi

.rccontrol-profile/bin/rccontrol self-init

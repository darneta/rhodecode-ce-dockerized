if [ ! -f .rcinstalled ]; then
	echo "RC not installed. Running install scripts...\n"
	
	echo "Installing VCSServer...\n"
	.rccontrol-profile/bin/rccontrol install VCSServer --accept-license '{"host":"'"$RHODECODE_HOST"'", "port":'"$RHODECODE_VCS_PORT"'}' --version 4.6.1 --offline

	echo "Installing RC Community edition...\n"
	.rccontrol-profile/bin/rccontrol install --accept-license Community  '{"host":"'"$RHODECODE_HOST"'", "port":'"$RHODECODE_HTTP_PORT"', "username":"'"$RHODECODE_USER"'", "password":"'"$RHODECODE_USER_PASS"'", "email":"'"$RHODECODE_USER_EMAIL"'", "repo_dir":"'"$RHODECODE_REPO_DIR"'", "database": "'"$RHODECODE_DB"'"}' --version 4.6.1 --offline

	sed -i "s/start_at_boot = True/start_at_boot = False/g" ~/.rccontrol.ini
	sed -i "s/self_managed_supervisor = False/self_managed_supervisor = True/g" ~/.rccontrol.ini

	touch .rccontrol/supervisor/rhodecode_config_supervisord.ini
	echo "[supervisord]" >> .rccontrol/supervisor/rhodecode_config_supervisord.ini
	echo "nodaemon = true" >> .rccontrol/supervisor/rhodecode_config_supervisord.ini
	
	.rccontrol-profile/bin/rccontrol self-stop

    touch .rcinstalled
fi

supervisord -c .rccontrol/supervisor/supervisord.ini

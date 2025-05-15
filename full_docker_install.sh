#!/bin/bash

# Ensure the script is running with the script's directory as its working directory
cd "$(dirname $0)"

# Docker has a convenience script to automatically install docker and docker compose on mutliple systems
run_convenience_script() {
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
}

# Verify the docker installation resulted docker being installed & warn if unfamiliar versions were installed
verify_install() {
	if which docker; then
		DOCKER_VERSION="$(docker --version | awk '{print $3}' | cut -d',' -f1)"
		DOCKER_COMPOSE_VERSION="$(docker compose version | awk '{print $4}' | cut -d',' -f1)"

		if [[ "${DOCKER_VERSION}" == "28.0.4" ]] ; then
			echo
			echo "Docker installed a known-good version [${DOCKER_VERSION}]."
			echo

			if [[ "${DOCKER_COMPOSE_VERSION}" == "v2.34.0" ]] ; then
				echo
				echo "Docker Compose installed a known-good version [${DOCKER_COMPOSE_VERSION}]."
				echo
			else
				echo
				echo "WARNING: Docker Compose installed a non known-good version [${DOCEKR_COMPOSE_VERSION}]."
				echo
				exit 1
			fi
		else
			echo
			echo "WARNING: Docker installed a non known-good version (not v28.0.4)."
			echo
			exit 1
		fi
	else
		echo
		echo "ERROR: Docker installation failed."
		echo
		exit 1
	fi
}

# There are various post-installation steps the docker install script doesn't normally do. They are conducted here.
do_post_install() {
	# Ensure normal users can use docker without 'sudo'
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker

	# Ensure docker & the specified containers run on startup
	sudo systemctl enable docker
	sudo systemctl start docker
}

echo "Downloading and Running Convenience Script..."
run_convenience_script
echo "Done."

echo "Verifying Installation..."
verify_install
echo "Done."

echo "Post-Installation Steps..."
do_post_install
echo "Done."

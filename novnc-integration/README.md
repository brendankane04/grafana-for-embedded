# Overview

## Quick Start

Run `docker compose up -d` to allow docker to see a vnc panel into a sandboxed container on the endpoint.

### Notes

* You can alter the contents of the sandboxed container by changing the Dockerfile in this directory.
* The container is set to run as privileged so that it can access USB devices.
* The container is sandboxed out of the host running the container, so it won't be able to use programs from the host & vice versa.
* There is a volume from the container to the host where they share all *.log files in /var/log/,  `/var/log/*.log`.

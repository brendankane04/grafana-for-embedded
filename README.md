# Grafana Server

This implementation of a Promtail->Loki->Grafana stack has been proven to work. You can download the repo, use the modified docker installation script to install docker on your machine, and run the server with docker compose easily

# Quick Start

Run the following steps to install docker to proper versions & set the right permissions

```bash
sudo chmod +x *.sh
./get-docker.sh
./post_install.sh
```
The `post_install.sh` will verify the installation. If that passes, you can safely run the following command to run the grafana server

```bash
docker compose up -d
```

If this doesn't work, there may be some issue with permissions with the associated volumes or for the ports

You can pull up the example dashboards in grafana with the following command. You may use firefox or any other browser.

```bash
firefox http://localhost:3000/dashboards
```
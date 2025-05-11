# 🖥️ Web Terminal Endpoint (Wetty)

This project sets up a **browser-based terminal** using [**Wetty**](https://github.com/butlerx/wetty). It allows users to access a shell session of the host machine through a web interface.

The terminal runs inside a Docker container using `docker-compose`, with **host networking** enabled for direct access to the desired port.

---

## 🚀 Getting Started

You will need `docker` and `docker compose` to run this project. Please follow the instructions in the root directory if you haven't already.

### Launch the Terminal

To start the container in detached mode:

```bash
docker-compose up -d
```

Once running, open the terminal in your browser:

```bash
firefox http://localhost:3020
```
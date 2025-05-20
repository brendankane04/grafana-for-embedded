.PHONY: simple_stack
simple_stack:
	@echo "Running the minimum stack for running a grafana instance..."
	docker compose -f docker-compose.yaml up -d grafana loki promtail 

	@echo ""
	@echo "Grafana is running on http://localhost:3000"
	@echo ""

.PHONY: full_stack
full_stack:
	@echo "Running the grafana stack and all the additional data collectors..."
	@echo "WARNING: This configuration uses various devices (/dev/ttyACM0, /dev/video0, various tcp ports, etc) on the host machine. Please ensure they are available."

	# Run the minimum stack
	docker compose -f docker-compose.yaml up -d grafana loki promtail 

	# Run the additional data collectors
	docker compose -f live-camera-panel/docker-compose.yaml up -d
	docker compose -f serial-logger/docker-compose.yaml up -d
	docker compose -f remote-terminal/docker-compose.yaml up -d
	docker compose -f novnc-integration/docker-compose.yaml up -d

	@echo ""
	@echo "Grafana is running on http://localhost:3000"
	@echo ""

LOKI_IP_ADDR ?= $(error Please set LOKI_IP_ADDR environment variable: export LOKI_IP_ADDR=your.loki.server)

.PHONY: simple_agent
simple_agent: 
	@echo "Running the minimum stack for an agent node..."
	@echo "WARNING: This configuration uses various devices (/dev/ttyACM0, /dev/video0, various tcp ports, etc) on the host machine. Please ensure they are available."
	@echo "Using Loki server at: $(LOKI_IP_ADDR)"
	@sed "s/<LOKI SERVER URL\/HOSTNAME\/IP>/$(LOKI_IP_ADDR)/" agent-compose.yaml > agent-compose.tmp.yaml

	docker compose -f agent-compose.tmp.yaml up -d promtail 
	@rm agent-compose.tmp.yaml

.PHONY: full_agent
full_agent: 
	@echo "Running the full stack for an agent node..."
	@echo "Using Loki server at: $(LOKI_IP_ADDR)"
	@sed "s/<LOKI SERVER URL\/HOSTNAME\/IP>/$(LOKI_IP_ADDR)/" agent-compose.yaml > agent-compose.tmp.yaml

	docker compose -f agent-compose.tmp.yaml up -d promtail 
	@rm agent-compose.tmp.yaml

	# Run the additional data collectors
	docker compose -f live-camera-panel/docker-compose.yaml up -d
	docker compose -f serial-logger/docker-compose.yaml up -d
	docker compose -f remote-terminal/docker-compose.yaml up -d
	docker compose -f novnc-integration/docker-compose.yaml up -d

down:
	@echo "Stopping whichever docker containers are running..."
	docker compose -f docker-compose.yaml down

	# Stop the additional data collectors
	docker compose -f live-camera-panel/docker-compose.yaml down
	docker compose -f serial-logger/docker-compose.yaml down
	docker compose -f remote-terminal/docker-compose.yaml down
	docker compose -f novnc-integration/docker-compose.yaml down
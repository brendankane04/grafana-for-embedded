# Serial Logger

This component of the codebase is responsible for conveniently allowing the user to capture the input of serial ports on the host device and then send them to log files. These files can then be easily capture by promtail to be then viewed in grafana panels.

## Overview

The Serial Logger is designed to:
- Monitor multiple serial devices simultaneously
- Log device output to files in `/var/log`
- Run as a Docker container with device access
- Integrate with Grafana+Loki for log visualization

## Quick Start

To start simply set the `config.yaml` to the correct configuration to read from the serial device(s) you want to read from then run the docker container.

### Configuration

Configure your serial device(s) in `config.yaml`:

````yaml
devices:
  - device: /dev/ttyACM0    # Device path
    baudrate: 9600          # Baud rate
    logfile: device1.log    # Output log file name
  
  - device: /dev/ttyUSB0
    baudrate: 115200
    logfile: device2.log
````

### Running the docker container

Run the following commands to enter the `serial-logger` directory and run the container:

````bash
cd serial-logger
docker compose up -d
````

After this, you should find log file(s) in `var/log/` of your host machine containing the serial output of the device(s) you're capturing. 

See the example dashboards in grafana GUI to see how to visualize the text of a logfile in a grafana panel.
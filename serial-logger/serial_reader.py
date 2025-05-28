import yaml
import serial
import threading
import time
import os
import signal

# shut down gracefully (faster) on SIGINT or SIGTERM
def handle_signal(signum, frame):
    print(f"Received signal {signum}, shutting down gracefully...")
    exit(0)

CONFIG_FILE = "config.yaml"
RETRY_INTERVAL = 5  # seconds between retries

def read_serial(device_config):
    dev = device_config["device"]
    baud = device_config.get("baudrate", 9600)
    logfile = f"/var/log/{device_config['logfile']}"
    ser = None

    os.makedirs(os.path.dirname(logfile), exist_ok=True)

    while True:
        if ser is None:
            try:
                ser = serial.Serial(dev, baud, timeout=1)
                print(f"[{dev}] Connected successfully")
                print(f"[{dev}] Logging to {logfile}")
                with open(logfile, "a") as f:
                    f.write(f"[{dev} - Session Begin]\n")
            except serial.SerialException as e:
                print(f"[{dev}] Could not open serial port: {e}")
                time.sleep(RETRY_INTERVAL)
                continue

        try:
            with open(logfile, "a") as f:
                while True:
                    try:
                        line = ser.readline().decode('utf-8', errors='replace')
                        if line:
                            print(f"[{dev}] {line.strip()}")
                            f.write(f"[{dev}] {line.strip()}\n")
                            f.flush()
                    except (serial.SerialException, OSError) as e:
                        print(f"[{dev}] Connection lost: {e}")
                        f.write(f"[{dev} - Session End]\n")
                        break
                    except Exception as e:
                        print(f"[{dev}] Error: {e}")
                        break

        finally:
            if ser:
                try:
                    ser.close()
                    print(f"[{dev}] Port closed, will retry in {RETRY_INTERVAL} seconds")
                except:
                    pass
                ser = None

        time.sleep(RETRY_INTERVAL)

def main():
    try:
        with open(CONFIG_FILE, "r") as f:
            config = yaml.safe_load(f)
    except Exception as e:
        print(f"Error: Failed to load {CONFIG_FILE}: {e}")
        return

    for device in config.get("devices", []):
        t = threading.Thread(target=read_serial, name=f"Serial Reader ({device['device']})", args=(device,), daemon=True)
        t.start()

    # Keep main thread alive
    while True:
        time.sleep(1)

if __name__ == "__main__":
    # Set up signal handlers for graceful shutdown (received when the docker container is stopped)
    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)
    main()

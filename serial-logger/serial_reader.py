import yaml
import serial
import threading
import time
import os

CONFIG_FILE = "config.yaml"

def read_serial(device_config):
    dev = device_config["device"]
    baud = device_config.get("baudrate", 9600)
    logfile = f"/var/log/{device_config["logfile"]}"

    try:
        ser = serial.Serial(dev, baud, timeout=1)
    except serial.SerialException as e:
        print(f"[{dev}] Could not open serial port: {e}")
        return

    print(f"[{dev}] Logging to {logfile}")

    os.makedirs(os.path.dirname(logfile), exist_ok=True)

    with open(logfile, "a") as f:
        while True:
            try:
                line = ser.readline().decode('utf-8', errors='replace')
                if line:
                    print(f"[{dev}] {line.strip()}")
                    f.write(f"[{dev}] {line.strip()}\n")
                    f.flush()
            except Exception as e:
                print(f"[{dev}] Error: {e}")
                break

    ser.close()

def main():
    try:
        with open(CONFIG_FILE, "r") as f:
            config = yaml.safe_load(f)
    except Exception as e:
        print(f"Error: Failed to load {CONFIG_FILE}: {e}")
        return

    for device in config.get("devices", []):
        t = threading.Thread(target=read_serial, name=f"Serial Reader ({device["device"]})", args=(device,))
        t.start()

    # Keep main thread alive
    while True:
        time.sleep(1)

if __name__ == "__main__":
    main()

FROM python:3.12-slim

RUN pip install pyserial pyyaml

WORKDIR /app

COPY serial_reader.py /app/
COPY config/config.yaml /app/

RUN mkdir -p /var/log

CMD ["python", "serial_reader.py"]

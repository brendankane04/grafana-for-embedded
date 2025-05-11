FROM ubuntu:22.04
WORKDIR /app
RUN apt update && apt install -y motion
EXPOSE 8081
COPY ./config/motion.conf ./motion.conf
CMD ["motion", "-c", "/etc/motion/motion.conf"]

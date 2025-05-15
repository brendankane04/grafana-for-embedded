FROM dorowu/ubuntu-desktop-lxde-vnc

# This is needed to run apt properly (apt needs unlocked keys)
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] http://dl.google.com/linux/chrome/deb stable main" > /etc/apt/sources.list.d/google-chrome.list

# Extend the vnc panel by adding firmware-relevant programs
RUN apt-get update -q && apt-get install minicom openocd -y

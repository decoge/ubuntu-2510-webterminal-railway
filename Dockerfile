FROM ubuntu:25.10

# Fallback for local Docker; Railway will override this
ENV PORT=7681
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     ca-certificates wget curl git python3 python3-pip neofetch tini \
  && rm -rf /var/lib/apt/lists/*

# Install latest ttyd (auto-updating)
RUN wget -qO /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
  && chmod +x /usr/local/bin/ttyd

# Run neofetch on root shell startup
RUN echo "neofetch" >> /root/.bashrc

# Optional documentation hint
EXPOSE 7681

# Credentials come from Railway Variables
ENV USERNAME=root
ENV PASSWORD=change-me

# Proper signal handling (important on Railway)
ENTRYPOINT ["/usr/bin/tini","--"]

# Explicit bind + Railway PORT
CMD ["/bin/bash","-lc","/usr/local/bin/ttyd --writable -i 0.0.0.0 -p ${PORT} -c ${USERNAME}:${PASSWORD} /bin/bash"]

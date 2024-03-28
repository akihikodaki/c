FROM debian:bullseye-20240311

WORKDIR /root

COPY android-cuttlefish android-cuttlefish

RUN apt-get update && \
    apt-get install -y libegl-dev libgles-dev mesa-vulkan-drivers ssh sudo && \
    touch /.dockerenv && \
    cd android-cuttlefish && \
    bash ./build_debs.sh && \
    apt-get install -y -f ./*.deb && \
    systemctl mask modprobe@.service systemd-journald-audit.service \
                   sys-kernel-config.mount sys-kernel-debug.mount \
                   sys-kernel-tracing.mount systemd-logind.service \
                   systemd-modules-load.service && \
    usermod -aG cvdnetwork,kvm root

CMD ["systemd"]

ENV PATH $PATH:/root/bin

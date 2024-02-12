# Arguments
ARG DISTROIMAGE=manjarolinux/build
ARG DISTRONAME=Manjaro Linux

# Base
FROM docker.io/${DISTROIMAGE}

# Labels
LABEL org.opencontainers.image.title="xenorepo"
LABEL org.opencontainers.image.description="Custom ${DISTRONAME} repository"
LABEL org.opencontainers.image.authors="Matthew Holder"
LABEL org.opencontainers.image.documentation="https://github.com/6XGate/xenorepo"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="2.0.2"

# Define the volumes.
VOLUME ["/tmp", "/run", "/run/lock", "/var/cache/pacman/xeno"]

# Setup the container.
COPY ./docker/public/usr /usr
COPY ./docker/public/etc /etc

# Build the container.
ENV PKGDEST=/var/cache/pacman/xeno
USER builder
WORKDIR /builder
COPY --chown=builder:builder ./docker/build/initialize.sh /builder/initialize.sh
RUN /builder/initialize.sh

# Setup the build user.
COPY --chown=builder:builder ./docker/public/builder /builder

# Set the container initialization command.
ENTRYPOINT ["/builder/entrypoint.sh"]

# Start the cron deamon.
CMD ["/builder/startup.sh"]

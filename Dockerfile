FROM docker.io/archlinux:base-devel

COPY ./files/etc/pacman.xeno.conf /etc/pacman.d/xeno
COPY ./files/etc/aursync.crontab /etc/cron.d/aursync
COPY ./files/bin/xeno /usr/local/bin/xeno

VOLUME ["/tmp", "/run", "/run/lock", "/var/cache/pacman/xeno"]

    # Update everything and install base-devel and git.
RUN pacman -Syu --noconfirm --needed base-devel git pacutils perl-json-xs devtools pacman-contrib ninja cargo cronie glow && \
    # Create and setup the build user.
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --groups wheel --shell $(which bash) build && \
    # Create and setup a local repository.
    echo "Include = /etc/pacman.d/xeno" >> /etc/pacman.conf && \
    install -d /var/cache/pacman/xeno -o build && \
    # Prepare the xeno utility.
    chmod +x /usr/local/bin/xeno

USER build
COPY --chown=build:build ./files/init /home/build/init
COPY --chown=build:build ./files/startup /home/build/startup
COPY --chown=build:build ./files/update /home/build/update
COPY --chown=build:build ./files/README /home/build/README

    # Prepare the scripts.
RUN chmod +x /home/build/init && \
    chmod +x /home/build/startup && \
    chmod +x /home/build/update && \
    echo "glow /home/build/README" >> /home/build/.bashrc && \
    # Setup a local build folder for AUR builds.
    mkdir -p /home/build/sources && \
    cd /home/build/sources && \
    # Install AUR utilities.
    git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm && \
    # Clean-up and AUR builds.
    rm -rf /home/build/sources

# Clean up everything
RUN sudo pacman -Scc && paccache -rk0

WORKDIR /home/build

# Set the container initialization command.
ENTRYPOINT ["/home/build/init"]

# Start the cron deamon.
CMD ["/home/build/startup"]

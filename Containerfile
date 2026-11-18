FROM registry.access.redhat.com/ubi10/ubi

RUN dnf install -y ca-certificates curl-minimal git tar gzip \
    && dnf clean all

# Install the native CLI using OpenCode's official installer.
RUN curl -fsSL https://opencode.ai/v2/install -o /tmp/install-opencode.sh \
    && bash /tmp/install-opencode.sh --no-modify-path \
    && mv /root/.opencode/bin/opencode /usr/local/bin/opencode \
    && rm -f /tmp/install-opencode.sh \
    && opencode --version

# OpenShift assigns an arbitrary UID that belongs to the root group.
ENV HOME=/opt/app-root/src \
    XDG_DATA_HOME=/opt/app-root/src/.local/share \
    XDG_CONFIG_HOME=/opt/app-root/src/.config \
    XDG_CACHE_HOME=/opt/app-root/src/.cache \
    XDG_STATE_HOME=/opt/app-root/src/.local/state

RUN mkdir -p "${XDG_DATA_HOME}/opencode/log" \
        "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_STATE_HOME}" /workspace \
    && chgrp -R 0 /opt/app-root /workspace \
    && chmod -R g=u /opt/app-root /workspace

WORKDIR /workspace
USER 1001

ENTRYPOINT ["opencode"]

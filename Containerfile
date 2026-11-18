FROM registry.access.redhat.com/ubi10/ubi

RUN dnf install -y ca-certificates curl-minimal git tar gzip \
    && dnf clean all

# Install the native CLI using OpenCode's official installer.
RUN curl -fsSL https://opencode.ai/v2/install -o /tmp/install-opencode.sh \
    && bash /tmp/install-opencode.sh --no-modify-path \
    && mv /root/.opencode/bin/opencode /usr/local/bin/opencode \
    && rm -f /tmp/install-opencode.sh \
    && opencode --version

WORKDIR /workspace

ENTRYPOINT ["opencode"]

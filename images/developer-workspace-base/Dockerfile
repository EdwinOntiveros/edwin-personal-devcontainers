# syntax=docker/dockerfile:1.7

FROM debian:bookworm-slim@sha256:7b140f374b289a7c2befc338f42ebe6441b7ea838a042bbd5acbfca6ec875818

#-----------------------------------------
# Container Metadata
#-----------------------------------------

LABEL org.opencontainers.image.title="Developer Workspace Base"
LABEL org.opencontainers.image.description="Reusable secure Linux Development Environment"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="Edwin Ontiveros"
LABEL org.opencontainers.image.source="https://github.com/EdwinOntiveros/personal-dev-containers"
LABEL org.opencontainers.image.authors="Edwin Jossiel Ontiveros Montanez"


#-----------------------------------------
# Shell configuration
#-----------------------------------------

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#-----------------------------------------
# Environment
#-----------------------------------------
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm-256color
ENV EDITOR=vim
ENV VISUAL=vim

#-----------------------------------------
# Common developer tools
#-----------------------------------------

# certificates and networking
# source control
# terminal utilities
# development utilities
# process / debug utilities
# locale support
RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    openssl \
    git \
    openssh-client \
    bash-completion \
    less \
    nano \
    vim-tiny \
    jq \
    ripgrep \
    fd-find \
    unzip \
    zip \
    procps \
    iputils-ping \
    netcat-openbsd \
    sudo \
    locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*


#-----------------------------------------
# Create non-root developer user
#-----------------------------------------

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN groupadd \
    --gid ${USER_GID} \
    ${USERNAME} \
    && useradd \
    --uid ${USER_UID} \
    --gid ${USER_GID} \
    --create-home \
    --no-log-init \
    --shell /bin/bash \
    ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

#-----------------------------------------
# Workspace dir
#-----------------------------------------

RUN mkdir -p /workspace \
    && chown -R ${USERNAME}:${USERNAME} /workspace

WORKDIR /workspace

# switch to non-root user
USER ${USERNAME}

# small common git configs
RUN git config --global init.defaultBranch mainline \
    && git config --global core.editor vim

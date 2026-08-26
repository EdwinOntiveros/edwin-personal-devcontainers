ARG BASE_IMAGE=ghcr.io/edwinontiveros/developer-workspace-base
ARG DIGEST=sha256:7969437e9bd5dff0aa4eaefed7ff1191d30cdac6fb60b16daac3243278d22064

FROM ${BASE_IMAGE}@${DIGEST} AS base_image

ARG USER=developer
ARG UID=1000
ARG GID=1000
ARG DOTNET_VERSION=10.0

USER root

ENV DOTNET_ROOT='/usr/share/dotnet'
ENV PATH="${DOTNET_ROOT}:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libc6 \
    libgcc-s1 \
    libgssapi-krb5-2 \
    libicu-dev \
    libssl3 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://dot.net/v1/dotnet-install.sh \
    -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh \
    --channel ${DOTNET_VERSION} \
    --install-dir ${DOTNET_ROOT} \
    --no-path \
    && rm /tmp/dotnet-install.sh

RUN chown -R ${USER}:${USER} ${DOTNET_ROOT}

USER ${USER}

RUN dotnet --info \
    && dotnet --version \
    && dotnet --list-sdks

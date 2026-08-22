ARG BASE_IMAGE=ghcr.io/edwinontiveros/developer-workspace-base
ARG DIGEST=sha256:7969437e9bd5dff0aa4eaefed7ff1191d30cdac6fb60b16daac3243278d22064

FROM ${BASE_IMAGE}@${DIGEST} AS base_image

ARG USER=developer
ARG UID=1000
ARG GID=1000
ARG PYTHON_VERSION=3.13
ARG UV_VERSION=0.12.5

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_CACHE_DIR=/home/${USER}/.cache/uv \
    UV_INSTALL_DIR=/usr/local/bin \
    UV_PYTHON_INSTALL_DIR=/opt/uv/python \
    UV_PYTHON_BIN_DIR=/usr/local/bin \
    UV_PYTHON_PREFERENCE=only-managed \
    PYTHON_VERSION=${PYTHON_VERSION} \
    UV_VERSION=${UV_VERSION}

USER root

# create uv cache dir, with permissions for developer user
RUN install -d \
    -o "${UID}" \
    -g "${GID}" \
    "${UV_CACHE_DIR}"

RUN install -d \
    -o "${UID}" \
    -g "${GID}" \
    "${UV_PYTHON_INSTALL_DIR}"

ADD https://astral.sh/uv/install.sh /tmp/install-uv.sh
RUN sh /tmp/install-uv.sh \
    && uv --version \
    && rm -f /tmp/install-uv.sh

# install the managed uv python runtime
RUN uv python install --default ${PYTHON_VERSION} \
    && uv python find ${PYTHON_VERSION} \
    && uv python list

# give non root user permissions to python executable
RUN chown -R ${USER}:${USER} ${UV_PYTHON_INSTALL_DIR} \
    && chown -R ${USER}:${USER} ${UV_CACHE_DIR}

# switch to non-root user
USER ${USER}

WORKDIR /workspace

# Validate runtime setup is complete
RUN python --version \
    && python3 --version \
    && uv --version

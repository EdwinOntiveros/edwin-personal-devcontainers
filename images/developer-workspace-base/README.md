# Developer Workspace Base

A minimal, secure, reusable Linux development image designed to serve as the foundation for language-specific development containers.

This image intentionally contains **no programming language runtimes**. Its purpose is to provide a consistent developer environment that can be extended into specialized images such as Python, C++, .NET, or TypeScript.

---

## Design Goals

* Secure by default
* Reproducible builds
* Language agnostic
* Minimal attack surface
* Least-privilege development
* OCI compliant
* Multi-stage image inheritance
* Suitable for VS Code Dev Containers and CI/CD pipelines

---

## Image Responsibilities

The base image provides:

* Debian Bookworm Slim
* Non-root developer user
* Bash shell
* Git and OpenSSH client
* Common CLI utilities
* Networking and debugging tools
* UTF-8 locale configuration
* Standard development workspace

The image deliberately **does not include**:

* Python
* Node.js
* .NET SDK
* C/C++ toolchains
* Playwright
* Docker CLI
* Cloud CLIs
* Kubernetes tools
* VS Code extensions
* Project dependencies

These belong in derived images.

---

## Installed Packages

### Networking

* curl
* wget
* openssl
* ca-certificates

### Source Control

* git
* openssh-client

### Terminal Utilities

* bash-completion
* less
* nano
* vim-tiny

### Development Utilities

* jq
* ripgrep
* fd-find
* zip
* unzip

### Debugging

* procps
* iputils-ping
* netcat-openbsd

### System

* locales
* sudo

---

## Default Environment

| Variable   | Value            |
| ---------- | ---------------- |
| `LANG`     | `en_US.UTF-8`    |
| `LC_ALL`   | `en_US.UTF-8`    |
| `LANGUAGE` | `en_US:en`       |
| `TERM`     | `xterm-256color` |
| `EDITOR`   | `vim`            |
| `VISUAL`   | `vim`            |

---

## Default User

The image runs as a non-root user.

| Property  | Value             |
| --------- | ----------------- |
| Username  | `developer`       |
| Shell     | `/bin/bash`       |
| Home      | `/home/developer` |
| Workspace | `/workspace`      |

---

## Image Hierarchy

This image is intended to be the root of a family of reusable development images.

```text
Developer Workspace Base
│
├── Python Dev
│   └── Python + Playwright
│
├── C++ Dev
│
├── .NET Dev
│
└── TypeScript Dev
```

Each derived image adds only the tooling required for its language or framework.

---

## Example Usage

Run an interactive shell:

```bash
docker run --rm -it <image-name> bash
```

Use as a base image:

```dockerfile
FROM ghcr.io/EdwinOntiveros/developer-workspace-base:latest

# Install language runtime
# Install language-specific tooling
```

---

## Security Philosophy

This image follows several security best practices:

* Uses the official Debian Bookworm Slim image
* Pins the base image by digest
* Runs as a non-root user
* Installs packages without recommended dependencies
* Keeps the image language agnostic
* Reduces unnecessary packages and services
* Uses OCI image metadata
* Designed for reproducible builds

Future releases will integrate:

* Trivy vulnerability scanning
* SBOM generation (Syft)
* Cosign image signing
* GitHub Actions build pipeline
* GitHub Container Registry publishing

---

## Repository Roadmap

* ✅ Developer Workspace Base (07/27/2026)
* ⏳ Python Development Image
* ⏳ Python + Playwright Image
* ⏳ C++ Development Image
* ⏳ .NET Development Image
* ⏳ TypeScript Development Image
* ⏳ VS Code Dev Containers
* ⏳ Docker Compose service templates
* ⏳ GitHub Actions CI/CD
* ⏳ Supply-chain security pipeline

---

## License

Licensed under the Apache 2.0 License.

Edwin Jossiel Ontiveros Montanez - 2026 ©️

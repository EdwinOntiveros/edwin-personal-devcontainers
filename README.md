# Edwin Personal Devcontainers

A collection of reusable, production-ready development container images for local development, CI/CD, and automation workflows.

Each image is independently versioned, tested, and published to the GitHub Container Registry (GHCR).

---

## Repository Layout

```text
.
├── .github/
│   └── workflows/          # CI/CD pipelines
├── images/
│   ├── developer-workspace-base/
│   └── ...
├── tests/
│   ├── helpers/            # Shared shell utilities
│   ├── suites/             # Reusable smoke test suites
│   └── images/             # Image-specific test entrypoints
└── README.md
```

---

## Repository Goals

- Build reusable development container images.
- Keep images modular and composable.
- Validate every image before publication.
- Publish immutable OCI images to GHCR.
- Reuse the same smoke-test framework across all images.

---

## CI/CD Pipeline

Each image follows the same pipeline:

```text
Lint
  │
  ▼
Build
  │
  ▼
Smoke Tests
  │
  ▼
Publish (push to mainline only)
```

### Lint

Performs static analysis on:

- Markdown
- Dockerfiles
- Shell scripts

### Build

- Builds the Docker image.
- Loads it into the local Docker daemon.
- Executes smoke tests.

### Publish

Only runs for pushes to `mainline`.

Publishes the validated image to GitHub Container Registry.

---

## Smoke Tests

Smoke tests are intentionally lightweight.

Their purpose is to verify that an image:

- Builds successfully
- Starts correctly
- Contains the expected tooling
- Has the expected user configuration
- Has the expected environment configuration

Shared functionality lives under:

```text
tests/helpers/
tests/suites/
```

Each image exposes a single entrypoint:

```text
tests/images/<image-name>/smoke.sh
```

---

## Adding a New Image

1. Create the image directory.

```text
images/my-image/
```

1. Add a `Dockerfile`.

2. Create a smoke test.

```text
tests/images/my-image/smoke.sh
```

1. Reuse existing suites whenever possible.

2. Add or update the corresponding workflow.

---

## Local Development

Run the workflow locally with `act`:

```bash
act pull_request
```

Build manually:

```bash
docker build \
    -f images/developer-workspace-base/Dockerfile \
    -t developer-workspace-base:test .
```

Run smoke tests:

```bash
docker run --rm \
    -v "$(pwd)/tests:/tests:ro" \
    developer-workspace-base:test \
    bash /tests/images/developer-workspace-base/smoke.sh
```

---

## Published Images

Images are published to GitHub Container Registry.

Example:

```text
ghcr.io/<owner>/developer-workspace-base
```

---

## Design Principles

- Single responsibility
- Reusable test suites
- OCI-compliant images
- Reproducible builds
- Minimal image size
- Fast CI execution
- Fail fast

---

## License

This repository is licensed under the terms of the Apache 2.0 License.

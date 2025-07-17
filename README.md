# [alpine-gcloud-sdk](https://hub.docker.com/r/itskigen/alpine-gcloud-sdk/)

A lightweight Docker image based on Alpine Linux that provides a complete development environment for Google Cloud Platform. This image includes the Google Cloud SDK and all necessary dependencies for building, deploying, and managing applications on GCP.

[![](https://images.microbadger.com/badges/image/itskigen/alpine-gcloud-sdk.svg)](https://microbadger.com/images/itskigen/alpine-gcloud-sdk "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/itskigen/alpine-gcloud-sdk.svg)](https://microbadger.com/images/itskigen/alpine-gcloud-sdk "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/itskigen/alpine-gcloud-sdk.svg)](https://microbadger.com/images/itskigen/alpine-gcloud-sdk "Get your own commit badge on microbadger.com")

## Features

This image includes:

- **Alpine Linux 3.18.4** - Lightweight base distribution
- **Google Cloud SDK** - Complete gcloud CLI with additional components
- **Java 11** (OpenJDK) - Required for various GCP tools
- **Python 3** - With pip and development headers
- **PostgreSQL libraries** - For database connectivity
- **Essential development tools** - gcc, make, git, curl, openssh

### Included Google Cloud Components

- `gcloud` - Google Cloud CLI
- `gsutil` - Cloud Storage utility
- `kubectl` - Kubernetes command-line tool
- `bq` - BigQuery command-line tool
- App Engine components (Go, Java, Python)
- Cloud Datastore Emulator
- Cloud Pub/Sub Emulator
- BigTable utilities
- Docker credential helper

## Quick Start

### Using the Pre-built Image

```bash
# Pull the latest image
docker pull itskigen/alpine-gcloud-sdk:master

# Run an interactive shell
docker run -it itskigen/alpine-gcloud-sdk:master /bin/bash

# Mount your project directory and run commands
docker run -v $(pwd):/workspace -w /workspace itskigen/alpine-gcloud-sdk:master gcloud version
```

### Authentication with Google Cloud

```bash
# Authenticate using service account key
docker run -v /path/to/service-account.json:/tmp/key.json \
  itskigen/alpine-gcloud-sdk:master \
  gcloud auth activate-service-account --key-file=/tmp/key.json

# Or mount your local gcloud config
docker run -v ~/.config/gcloud:/root/.config/gcloud \
  itskigen/alpine-gcloud-sdk:master \
  gcloud projects list
```

### Example: Deploy to Cloud Run

```bash
docker run -v $(pwd):/workspace -w /workspace \
  -v ~/.config/gcloud:/root/.config/gcloud \
  itskigen/alpine-gcloud-sdk:master \
  gcloud run deploy my-service --source . --region us-central1
```

## Building from Source

### Prerequisites

- Docker installed on your system
- Git (to clone this repository)

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/kigen/alpine-gcloud-sdk.git
cd alpine-gcloud-sdk

# Build the image
docker build -t alpine-gcloud-sdk .

# Or use the build hook script
chmod +x hooks/build
IMAGE_NAME=alpine-gcloud-sdk ./hooks/build
```

### Build Arguments

The Dockerfile supports the following build arguments:

- `BUILD_DATE` - Build timestamp (automatically set by build script)
- `VCS_REF` - Git commit hash (automatically set by build script)  
- `VERSION` - Version from VERSION file (automatically set by build script)

## Environment Variables

The image sets the following environment variables:

- `LANG=C.UTF-8` - Default locale
- `JAVA_HOME=/usr/lib/jvm/` - Java installation path
- `CLOUDSDK_PYTHON_SITEPACKAGES=1` - Enable Python site packages for gcloud
- `PATH` - Updated to include Java and gcloud binaries

## Volumes

- `/.config` - Mounted volume for persistent gcloud configuration

## Common Use Cases

### CI/CD Pipelines

Use this image in your CI/CD pipelines for Google Cloud deployments:

```yaml
# GitHub Actions example
- name: Deploy to GCP
  uses: docker://itskigen/alpine-gcloud-sdk:master
  with:
    args: gcloud run deploy --source .
```

### Development Environment

```bash
# Create a development container
docker run -it --name gcp-dev \
  -v $(pwd):/workspace \
  -v ~/.config/gcloud:/root/.config/gcloud \
  itskigen/alpine-gcloud-sdk:master
```

### Database Operations

```bash
# Connect to Cloud SQL using PostgreSQL tools
docker run -it itskigen/alpine-gcloud-sdk:master \
  gcloud sql connect my-instance --user=postgres
```

## Version Information

- Current version: Check the [VERSION](VERSION) file
- Base image: Alpine Linux 3.18.4
- Java version: OpenJDK 11.0.17+8
- Google Cloud SDK: Latest from rapid release channel

## Troubleshooting

### Common Issues

1. **Authentication errors**: Ensure you've properly mounted your gcloud config or service account key
2. **Permission issues**: The container runs as root by default
3. **Missing tools**: All major GCP tools are included; if you need additional packages, consider extending this image

### Getting Help

- Check the [Google Cloud SDK documentation](https://cloud.google.com/sdk/docs)
- Review [Docker Hub page](https://hub.docker.com/r/itskigen/alpine-gcloud-sdk/) for image details
- Open an issue in this repository for image-specific problems

## Contributing

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test the build: `docker build -t test-alpine-gcloud-sdk .`
5. Submit a pull request

## License

This project is maintained by [254Bit](https://www.254bit.com/). See the Dockerfile labels for detailed metadata.

## Automated Builds

This image is automatically built and pushed to Docker Hub when changes are pushed to the master branch via GitHub Actions.
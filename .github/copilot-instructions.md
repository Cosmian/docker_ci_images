# GitHub Copilot Workspace Instructions

## Project Overview

This repository contains Docker CI images used in the Cosmian CI/CD pipeline. The repository builds and maintains standardized Docker images for different operating systems used in continuous integration workflows.

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions workflow for building and pushing images
├── Dockerfile.ubuntu22         # Ubuntu 22.04 based image with documentation tools
├── Dockerfile.rockylinux8      # Rocky Linux 8.9 based image with development tools
├── Dockerfile.rockylinux9      # Rocky Linux 9.3 based image with development tools
└── README.md                   # Basic project description
```

## Docker Images

### Ubuntu 22.04 (`Dockerfile.ubuntu22`)
- **Purpose**: Documentation and publishing pipeline
- **Base**: ubuntu:22.04
- **Key packages**: MkDocs, pandoc, LaTeX, Python documentation tools
- **Registry**: `cosmian/ubuntu22`
- **Use case**: Building documentation, generating PDFs, markdown processing

### Rocky Linux 8 (`Dockerfile.rockylinux8`)
- **Purpose**: Development environment for RHEL 8 compatible systems
- **Base**: rockylinux:8.9
- **Key packages**: GCC, development tools, GTK libraries
- **Registry**: `cosmian/rockylinux8`
- **Use case**: Building and testing applications on RHEL 8 compatible systems

### Rocky Linux 9 (`Dockerfile.rockylinux9`)
- **Purpose**: Development environment for RHEL 9 compatible systems
- **Base**: rockylinux:9.3
- **Key packages**: GCC, development tools, GTK libraries
- **Registry**: `cosmian/rockylinux9`
- **Use case**: Building and testing applications on RHEL 9 compatible systems

## Development Guidelines

### Adding New Docker Images

1. **Naming Convention**: Use `Dockerfile.{os}{version}` format
2. **Base Image Selection**: Use specific version tags with SHA256 hashes for reproducibility
3. **Package Installation**: 
   - Group related packages in single RUN commands to reduce layers
   - Use `--no-install-recommends` for apt-get to minimize image size
   - Clean package caches after installation
4. **CI Integration**: Add new images to the matrix in `.github/workflows/ci.yml`

### Dockerfile Best Practices

- **Layer Optimization**: Combine related commands in single RUN statements
- **Security**: Use specific base image versions with SHA256 hashes where possible
- **Reproducibility**: Pin package versions when critical for builds
- **Documentation**: Comment complex installations or workarounds

### CI/CD Workflow

The GitHub Actions workflow (`.github/workflows/ci.yml`):
- Triggers on every push to any branch
- Builds all Docker images in parallel using matrix strategy
- Pushes to Docker Hub registry under `cosmian/` namespace
- Requires `DOCKER_HUB_PWD` secret for authentication

### Modifying Existing Images

1. **Test Changes**: Build locally before committing
2. **Version Considerations**: Understand impact on dependent CI pipelines
3. **Documentation**: Update this file if adding significant new capabilities
4. **Validation**: Ensure images build successfully in CI

### Local Development

```bash
# Build a specific image locally
docker build -f Dockerfile.ubuntu22 -t test-ubuntu22 .

# Test image functionality
docker run --rm -it test-ubuntu22 /bin/bash

# Check installed packages
docker run --rm test-ubuntu22 dpkg -l  # for Ubuntu
docker run --rm test-rockylinux8 rpm -qa  # for Rocky Linux
```

## Common Tasks

### Adding Python Packages (Ubuntu image)
- Add to the pip3 install command in the existing RUN layer
- Consider using requirements.txt for complex dependency management

### Adding System Packages
- **Ubuntu**: Add to existing `apt-get install` command
- **Rocky Linux**: Add to existing `dnf install` command
- Remember to update package cache cleanup commands

### Updating Base Images
- Check for security updates regularly
- Update SHA256 hashes when changing base image versions
- Test thoroughly as base image changes can have wide impact

## Troubleshooting

### Build Failures
- Check package availability for target OS version
- Verify package names (they may differ between distributions)
- Review dependency conflicts

### Size Issues
- Use multi-stage builds if needed
- Combine RUN commands to reduce layers
- Remove unnecessary files in the same layer they're created

### CI Issues
- Verify Docker Hub credentials and permissions
- Check matrix configuration syntax
- Ensure all referenced Dockerfiles exist

## Integration Notes

These images are designed to be consumed by other Cosmian projects' CI pipelines. Changes should be coordinated with teams using these images to avoid breaking dependent builds.
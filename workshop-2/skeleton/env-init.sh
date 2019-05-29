#!/usr/bin/env sh

# latest version is pulled
docker image pull zenika/terraform-azure-cli

# launch container with current folder mounted
docker container run -it -v "$(pwd)":/workspace zenika/terraform-azure-cli:latest

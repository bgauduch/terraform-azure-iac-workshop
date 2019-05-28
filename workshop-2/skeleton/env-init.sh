#!/usr/bin/env sh

# launch container with current folder mounted
docker container run -it -v "$(pwd)":/workspace zenika/terraform-azure-cli:latest

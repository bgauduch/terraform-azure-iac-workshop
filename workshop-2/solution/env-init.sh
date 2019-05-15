#!/usr/bin/env sh

# pull docker image
docker pull codersociety/terraform-azure-cli

# launch container with current folder mounted
docker container run -it -v "$(pwd)":/root codersociety/terraform-azure-cli

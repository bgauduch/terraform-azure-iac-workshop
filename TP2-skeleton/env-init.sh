#!/usr/bin/env sh

set -eo pipefail

# pull docker image
bash -c "docker pull codersociety/terraform-azure-cli"

# launch container with current folder mounted
bash -c "docker container run -it -v $(pwd):/root codersociety/terraform-azure-cli"

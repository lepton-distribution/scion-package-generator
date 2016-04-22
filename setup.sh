#!/bin/bash

# copy config files from the mount directory
# to the current user directory
if [ -d /mnt/config ]; then
    cp -s /mnt/config/.* ~/
fi

# check if git config is defined
if [[ ! -f ~/.gitconfig ]]; then
    echo ".gitconfig is not defined"
    exit 1
fi

if [[ ! -f ~/.pypirc ]]; then
    echo ".pypirc is not defined"
    exit 1
fi

#
# clone scion python module
#
# first check if a non default repository is given (passed via environment variable, for tests)
# if not, initialize to the default
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/lepton-distribution/seed.scions.git}"

if [ ! -d /code ]; then
    echo "Cloning $REPOSITORY_URL at the latest revision"
    cd /
    git clone "$REPOSITORY_URL" /code
fi

cd /code
changes --help

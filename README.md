# Use case

This package permits the building of a docker image that permits to generate a python module available on Pypi.

It uses a python package named [changes](https://github.com/michaeljoseph/changes), made to ease this process of tagging versions and upload them to Pypi

# Building the image

`docker build -t scion .`

The resulting image will be made available on the [Docker Hub](https://hub.docker.com) under the namespace _lepton/scion-module-generator_.

# Using the image

There are 2 config files used by this image :
* `config/.gitconfig` : to specify your git credentials. An example file is given in `config/.gitconfig.example`, which must be renamed in `config/.gitconfig`
* `config/.pypirc` : to specify your pypi credentials. An example file is given in `config/.pypirc.example`, which must be renamed in `config/.pypirc`

The config files are mounted in the container (under `/mnt/config/` and from there linked to the user home account).
That way, changes are immediately operational.

The package repository is cloned into the container (standard case) before giving the hand to manually launch `changes` commands, unless a host directory is mounted in the container via a -v directive (see below)

## Using the default repository, cloned at container launch

`docker run -it -v /path/to/config/directory:/mnt/config scion`

The default repository is cloned at container launch, in the last revision. Should be the "standard" case.

## Overriding default repository, cloned at container launch

The url of the repository to package can be specified via the REPOSITORY_URL environment variable

`docker run -it -v /path/to/config/directory:/mnt/config -e REPOSITORY_URL=https://github.com/user/other_repository.git scion`

This is useful mainly with a forked repository, that we want to be cloned instead of the default one.

Apart the repository url, works the same as previous case.

## Using a host repository

`docker run -it -v /path/to/config/directory:/mnt/config -v /path/to/package/directory:/code scion`

In this case, the default repository is not cloned at container launch, but the host directory is used instead.

This is useful when package code is worked out, because modifications made in the host directory are immediately available in the container.

# Commands to launch in the container

You will first need to go in the `/code` directory, where the package code is available.

`cd /code`

## List available commands
Will list commands available

`changes`

## Change the package version

This done via the `changes scion bump_version` command.

=> **This modifies the `__version__` attribute present in the `scion/__init__.py` file.**

Some parameters can be given to specify which numbers must modified

### Increment patch version (third number)
`changes -p scion bump_version`

### Increment minor version (second number)
`changes -m scion bump_version`

### Increment patch version (third number)
`changes -M scion bump_version`

## Generate a changelog
Will update the CHANGELOG.md with the commit history since the last version

`changes scion changelog`

## Build the package
Will build the wheel and tar.gz versions of the package.
Resulting file are stored in `dist/` directory

`changes scion build`

## Upload package to Pypi

The test or production Pypi server can be chosen by passing the --pypi=test (default is production, aka pypi repository)

The credentials stored in `config/.pypirc` are used to connect
A minima, the file should contain credentials for the production account.

### Upload to Pypi test server

`changes scion upload --pypi=test`

A successful upload will show the package on the home of [Pypi Test Server](https://testpypi.python.org/pypi/)

### Upload to Pypi production server

`changes scion upload`

A successful upload will show the package on the home of [Pypi Production Server](https://pypi.python.org/pypi/)

## Tag the repository with version number

**Warning : This will commit to the git repository of the package !**

The [github].token property in the `config/.gitconfig` file should be filled, to permit the use of the github api to perform operations.

This token can be generated at  https://github.com/settings/tokens/new (you must be connected to your account to issue an api token)

A `git push`, followed by a `git tag` will be issued, tagging the repository with version set earlier in the process (via bump_version)

`changes scion tag`

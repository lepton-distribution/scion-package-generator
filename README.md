*USE CASE*

This package permits the building of a docker image that permits to generate a python module available on Pypi.

It uses a python package named [changes](https://github.com/michaeljoseph/changes), made to ease this process of tagging versions and upload them to Pypi

*BUILDING THE IMAGE*

`docker build -t scion .`

The resulting image will be made available on the [Docker Hub](https://hub.docker.com) under the namespace _lepton/scion-module-generator_.

*USING THE IMAGE*

There are 2 config files used by this image :
- `config/.gitconfig` : to specify your git credentials. An example file is given in `config/.gitconfig.example`, which must be renamed in `config/.gitconfig`
- `config/.pypirc` : to specify your pypi credentials. An example file is given in `config/.pypirc.example`, which must be renamed in `config/.pypirc`

The config files are copied into the container at launch, so if you need to change them (shouldn't happen often), you must exit the container and launch it again.

The repository is cloned into the container before giving the hand to manually launch `changes` commands.

**Using the default repository**

`docker run -it -v /path/to/config/directory scion`

**Overriding default repository**

The url of the repository to package can be specified via the REPOSITORY_URL environment variable

`docker run -it -v /path/to/config/directory:/mnt/config:ro -e REPOSITORY_URL=https://github.com/user/other_repository.git scion`

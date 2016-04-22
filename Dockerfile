FROM python:3.4-slim
MAINTAINER Cédric Gros <c.gros@o10ee.com>

###############
# Base packages
###############

# install git to be able to fetch scions.py code from repository
RUN apt-get update
RUN apt-get install -y --no-install-recommends git

# install 'file' package, used by python-magic
RUN apt-get install -y --no-install-recommends file

#################
# Python packages
#################

# upgrade pip to last version
RUN pip install --upgrade pip

# install virtualenv
RUN pip install virtualenv

# install packaging tool
RUN pip install changes

#################
# Scripts
#################

# Copy the setup script
ADD setup.sh /setup.sh

# first launch setup script
# and give a shell to launch some commands manually
CMD bash -C '/setup.sh';'bash'

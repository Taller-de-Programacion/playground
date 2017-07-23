# Create a docker image with (you need to be in the same working directory
# where this Dockerfile is):
#
#   $ docker build -t playground .
#
# Check that the image has built correctly with:
#
#   $ docker images
#
# Start the docker running an *ephemeral* bash session with:
#
#   $ docker run --rm -it playground
#
# Ephemeral means that any change inside of the container will be
# lost once you exit the bash session.
# This is a throw away container.

# Use the official image for Ubuntu https://hub.docker.com/_/ubuntu/
FROM ubuntu:16.04

# Update and install the needed packages.
# 
# Use DEBIAN_FRONTEND=noninteractive as a environment variable to let
# apt-get know that he cannot ask to the user anything; he needs to 
# use a default setting for everything.
# Don't use the docker's command ENV to set DEBIAN_FRONTEND as that will
# be persistent and an user with an interactive shell session open to this
# container may see this as an unexpected default.
#
# Use --no-install-recommends to avoid installing anything except 
# the essential
#
# Also, specify exactly what version of the packages must be installed. This
# will avoid issues if a new package's version is added and you don't notice
# it but it gets installed.
# This is known as version pinning.
RUN    apt-get -y update  \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
            --no-install-recommends \
            # C and C++ compilers
            gcc=4:5.3.1-1ubuntu1 \
            g++=4:5.3.1-1ubuntu1 \
    # finally, clean up to reduce images's size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Run a shell so we can play 
CMD ["/bin/bash"]

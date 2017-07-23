# Create a docker image with (you need to be in the same working directory
# where this Dockerfile is):
#
#   $ docker build -t playground .
#
# Check that the image has built correctly with:
#
#   $ docker images

# Use the official image for Ubuntu https://hub.docker.com/_/ubuntu/
FROM ubuntu:16.04

# Run a shell so we can play 
CMD ["/bin/bash"]

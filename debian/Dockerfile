# Use an official Debian runtime as a base image
FROM debian:buster

# Set the working directory to /app
WORKDIR /documents

# Copy the current directory contents into the container at /app
COPY . /documents

# Install the required development packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
  apt-get install apt-utils -y && \
  apt-get upgrade -y && \
  /bin/bash -c "xargs -a <(awk '/^\s*[^#]/' packages.txt) -r -- apt-get install -y" && \
  apt-get purge -y *-doc && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Prepare the environment
RUN echo "LC_ALL=\"C.UTF-8\"" >>/etc/default/locale
RUN locale-gen C.UTF-8 && update-locale LANG="C.UTF-8"
RUN echo "a4" >/etc/papersize

# Install any needed packages specified in requirements.txt
RUN pip3 install --upgrade pip
RUN pip install --upgrade wheel
RUN pip install -r requirements.txt

# Define container name
ENV NAME doc-builder

# Open a terminal when the container launches
CMD ["/bin/bash", "-login"]

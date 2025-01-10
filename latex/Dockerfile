# Use an official Debian runtime as a base image
FROM debian:bookworm

# Adjust system parameters
ENV DEBIAN_FRONTEND="noninteractive"

# Use Bash as default shell for more command-line flexibility
SHELL ["/bin/bash", "-c"]

# Install the required system packages
WORKDIR /root/tmp
COPY packages-system.txt ./
RUN apt-get update -y && \
    apt-get install apt-utils -y && \
    /bin/bash -c "xargs -a <(awk '/^\s*[^#]/' packages-system.txt) -r -- apt-get install -y" && \
    apt-get purge -y \*-doc && \
    apt-get clean && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/*

# Prepare the environment
RUN echo "C.UTF-8 UTF-8" >/etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen && \
    locale-gen && \
    update-locale LANG="C.UTF-8" && \
    echo "LANG=\"C.UTF-8\"" >/etc/default/locale && \
    echo "LC_ALL=\"C.UTF-8\"" >>/etc/default/locale && \
    echo "a4" >/etc/papersize

# Install the required documentation packages
WORKDIR /root/tmp
COPY packages-doc.txt ./
RUN apt-get update && \
    /bin/bash -c "xargs -a <(awk '/^\s*[^#]/' packages-doc.txt) -r -- apt-get install -y" && \
    apt-get purge -y \*-doc && \
    apt-get clean && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/*

# Install a recent version of pandoc
WORKDIR /root/tmp
RUN wget 'https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-1-amd64.deb' && \
    apt-get update -y && \
    apt-get install -y ./pandoc-3.1.11.1-1-amd64.deb && \
    apt-get purge -y \*-doc && \
    apt-get clean && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/*

# Create a non-privileged user
WORKDIR /root
RUN useradd \
        --comment 'Document Builder' \
        --create-home \
        --home-dir /librarian \
        --no-log-init \
        --shell /bin/bash \
        librarian </dev/null && \
    echo 'export PATH="/librarian/bin:${PATH}"' >>/librarian/.bashrc

# Install any needed packages specified in requirements.txt
WORKDIR /librarian/tmp
COPY requirements.txt ./
RUN python3 -m venv "/librarian/python-doc-env" && \
    . "/librarian/python-doc-env/bin/activate" && \
    python -m pip install --upgrade pip && \
    python -m pip install --upgrade setuptools && \
    python -m pip install --upgrade wheel && \
    python -m pip install --upgrade -r requirements.txt && \
    deactivate

# Activate the environment at shell startup
RUN echo '. "/librarian/python-doc-env/bin/activate"' >>/librarian/.profile

# Clean-up the mess
WORKDIR /root
RUN rm -rf /librarian/tmp /root/tmp

# Switch to the non-privileged user
WORKDIR /librarian
RUN chown -R librarian:librarian /librarian
USER librarian
ENV HOME /librarian

# Define the container name
LABEL name="doc-latex"
LABEL version="2024.1"
LABEL maintainer="Yann Pouillon <devops@materialsevolution.es>"

# Open a terminal when the container launches
ENV BASH_ENV="/etc/profile"
CMD ["/bin/bash", "--login"]

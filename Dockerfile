FROM jenkins/jenkins:lts-jdk11

# Switch to root to install packages
USER root

# Install necessary packages
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Switch back to jenkins user
USER jenkins

# Install plugins with dependency resolution
RUN jenkins-plugin-cli --plugins \
    blueocean \
    docker-workflow \
    json-path-api \
    token-macro \
    github \
    favorite \
    --verbose
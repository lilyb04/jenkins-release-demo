FROM jenkins/jenkins:lts

USER root

# Instalar Docker CLI (cliente), zip, unzip y certificados
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        unzip \
        zip && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean

# Permitir a Jenkins usar docker
RUN groupadd -f docker && \
    usermod -aG docker jenkins

ENV DOCKER_HOST=unix:///var/run/docker.sock

USER jenkins
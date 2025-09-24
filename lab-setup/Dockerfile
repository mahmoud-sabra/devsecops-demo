FROM jenkins/jenkins:2.504.3-jdk21

USER root

# Install system dependencies, Docker CLI, and Python
RUN apt-get update && apt-get install -y \
    lsb-release ca-certificates curl unzip gnupg software-properties-common \
    python3 python3-pip python3-venv build-essential \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install SonarQube Scanner CLI
ENV SONAR_SCANNER_VERSION=5.0.1.3006
ENV SONAR_SCANNER_DIR=/opt/sonar-scanner

RUN curl -sL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -o sonar-scanner.zip && \
    unzip sonar-scanner.zip -d /opt && \
    mv /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_DIR} && \
    ln -s ${SONAR_SCANNER_DIR}/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonar-scanner.zip

# Install Node.js 20 (LTS) and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    node -v && npm -v

# Install Semgrep and NodeJsScan via pip
RUN pip3 install --break-system-packages semgrep nodejsscan

# Install Gitleaks
RUN apt-get install wget && wget https://github.com/gitleaks/gitleaks/releases/download/v8.27.2/gitleaks_8.27.2_linux_x64.tar.gz && tar xvf gitleaks_8.27.2_linux_x64.tar.gz && cp gitleaks /usr/local/bin/ && chmod a+x /usr/local/bin/gitleaks
# Switch back to Jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"
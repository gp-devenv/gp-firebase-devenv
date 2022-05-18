FROM gpfister/base-devenv:20.04-0.1.0

# Versions
ENV NODE_VERSION="16.x"
ENV NPM_VERSION="8.10"
ENV FIREBASE_TOOLS_VERSION="10.9.2"
ENV ANGULAR_VERSION="13.3.6"

USER root

# Update all
RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get autoremove -y && \
    apt-get autoclean

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs && \
    apt-get autoclean -y && \
    apt-get autoremove -y

# Update npm
RUN npm i -g npm@${NPM_VERSION} firebase-tools@${FIREBASE_TOOLS_VERSION} @angular/cli@${ANGULAR_VERSION}

# Install development tools
RUN apt-get update && \
    apt-get install -y -o DPkg::Options::=--force-confdef openjdk-11-jre-headless git imagemagick && \
    apt-get install -y less ncdu nmap zsh zsh-theme-powerlevel9k vim vim-airline vim-airline-themes && \
    apt-get autoclean -y && \
    apt-get autoremove -y

# Add chromium
RUN add-apt-repository ppa:saiarcot895/chromium-dev && \ 
    apt-get update && \
    apt-get install -y chromium-browser
ENV CHROME_BIN=/usr/bin/chromium-browser

USER vscode
WORKDIR /home/vscode

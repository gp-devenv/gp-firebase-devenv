FROM ubuntu:20.04

# Timezone
ENV TZ="Europe/Paris"

# Versions
ENV NODE_VERSION="16.x"
ENV NPM_VERSION="8.7"
ENV FIREBASE_TOOLS_VERSION="10.7.0"
ENV ANGULAR_VERSION="13.3.3"

VOLUME [ "/home" ]

# Set the timezone
RUN apt-get update && \
    apt-get install tzdata -y

# Update all
RUN apt-get update && \
    apt-get full-upgrade -y

# Install essential packages
RUN apt-get update && \
    apt-get install -y build-essential curl wget software-properties-common && \
    apt-get autoclean -y && \
    apt-get autoremove -y

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

# Powerlevel 10K
WORKDIR /opt
RUN git clone https://github.com/romkatv/powerlevel10k.git

# Setup sudo
RUN apt-get update && \
    apt-get install -y sudo
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# Add chromium
RUN add-apt-repository ppa:saiarcot895/chromium-dev && \ 
    apt-get update && \
    apt-get install -y chromium-browser
ENV CHROME_BIN=/usr/bin/chromium-browser

# Default for users
WORKDIR /etc/skel
COPY .zshrc .
COPY .p10k.zsh .
COPY .vimrc .

# Adjust root user
WORKDIR /root
RUN chsh -s /bin/zsh root && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY .zshrc .
COPY .p10k.zsh .
COPY .vimrc .
RUN vim +'PlugInstall --sync' +qa

# Add vscode user
RUN useradd -s /bin/zsh -m vscode \
 && groupadd docker \
 && usermod -aG docker vscode
USER vscode
WORKDIR /home/vscode
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim +'PlugInstall --sync' +qa

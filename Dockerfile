# [Choice] Debian version: buster, stretch
ARG VARIANT=16
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:${VARIANT}

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
# ARG USERNAME=vscode
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# Install NeoVim 
# ARG INSTALL_NEOVIM="true"
COPY custom-scripts/neovim/* /tmp/library-scripts/
RUN bash /tmp/library-scripts/install-neovim.sh "${USERNAME}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install and configure zsh
COPY custom-scripts/zsh/* /tmp/library-scripts/
RUN /bin/bash /tmp/library-scripts/update-zsh.sh "${USERNAME}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Configure GIT ...
COPY custom-scripts/git/* /tmp/library-scripts/
RUN /bin/bash /tmp/library-scripts/configure-git.sh "${USERNAME}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Configure SSH ... 
# Configure commit signing
COPY custom-scripts/security/* /tmp/library-scripts/
RUN /bin/bash /tmp/library-scripts/configure-sign.sh "${USERNAME}" \
    && /bin/bash /tmp/library-scripts/configure-cert.sh \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Documentation
COPY custom-scripts/documentation/* /tmp/library-scripts/
RUN /bin/bash /tmp/library-scripts/install-documentation.sh \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

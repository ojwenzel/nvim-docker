FROM ubuntu:22.04

# setup build environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    ca-certificates \
    cmake \
    curl \
    g++ \
    gettext \
    git \
    gnupg \
    libtool \
    libtool-bin \
    make \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    unzip

# also install nodejs
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
     | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=18 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
     > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs

# clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cooperate Neovim with Python 3.
RUN pip3 install isort pynvim

# Cooperate NodeJS with Neovim.
RUN npm i -g neovim

WORKDIR /tmp

# Clone nvim
RUN git clone https://github.com/neovim/neovim.git
WORKDIR /tmp/neovim
# Build nvim
RUN git checkout stable && \
    rm -r build/ || true && \
    make CMAKE_BUILD_TYPE=Release install

# Remove repo from Image
WORKDIR /tmp
RUN rm -rf nvim

# Install Vim Plug.
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create directory for Neovim configuration files.
RUN mkdir -p /root/.config/nvim

# Copy Neovim configuration files.
COPY ./config/ /root/.config/nvim/

# Install Neovim extensions.
RUN nvim --headless +PlugInstall +qall

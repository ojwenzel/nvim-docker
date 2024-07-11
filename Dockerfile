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
    locales \
    locales-all \
    make \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    unzip

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en

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

# Create directory for virtual environments.
RUN mkdir -p /root/envs

# Cooperate Neovim with Python 3.
# Prepare main virtual environment (for language server features).
RUN cd /root/envs && python3 -m venv nvim_env
RUN /root/envs/nvim_env/bin/pip install isort pynvim

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

RUN git clone --depth 1 https://github.com/ojwenzel/atronvim_config.git ~/.config/nvim

RUN mkdir /workspace
WORKDIR /workspace

ENTRYPOINT ["bash", "-l", "-c", "nvim"]

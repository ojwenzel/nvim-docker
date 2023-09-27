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
    libtool \
    libtool-bin \
    make \
    ninja-build \
    pkg-config \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone https://github.com/neovim/neovim.git
WORKDIR /tmp/neovim
RUN git checkout stable && \
    rm -r build/ || true && \
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" && \
    make CMAKE_BUILD_TYPE=Release install && \
    export PATH="$HOME/neovim/bin:$PATH"

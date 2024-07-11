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
    make CMAKE_BUILD_TYPE=Release install

RUN git clone --depth 1 https://github.com/ojwenzel/atronvim_config.git ~/.config/nvim

RUN mkdir /workspace
WORKDIR /workspace

ENTRYPOINT ["bash", "-l", "-c", "nvim"]

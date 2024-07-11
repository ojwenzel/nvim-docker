FROM alpine:latest

RUN apk add \
    alpine-sdk \
    bash \
    bottom \
    curl \
    git \
    go \
    lazygit \
    lua \
    neovim \
    nodejs \
    npm \
    openssh \
    python3 \
    ripgrep \
    --update

# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# install config
ARG NVIM_CONFIG_REPO=git@github.com:ojwenzel/astronvim_config.git
RUN --mount=type=ssh git clone --depth 1 ${NVIM_CONFIG_REPO} ~/.config/nvim

# prepare workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# set nvim as command for container startup
CMD nvim

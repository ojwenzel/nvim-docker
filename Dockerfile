FROM alpine:latest

RUN apk add \
    bash \
    curl \
    git \
    lua \
    nodejs \
    npm \
    lazygit \
    bottom \
    openssh \
    python3 \
    go \
    neovim \
    ripgrep \
    alpine-sdk \
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

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
    python3 \
    go \
    neovim \
    ripgrep \
    alpine-sdk \
    --update

# prepare workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# set nvim as command for container startup
CMD nvim

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

# Replace with your own configuration repository to load a user configuration
RUN git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim

CMD nvim

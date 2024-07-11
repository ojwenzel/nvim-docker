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
COPY ./astronvim_config ~/.config/nvim

CMD nvim

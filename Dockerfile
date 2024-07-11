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
    sudo \
    ripgrep \
    --update

# Install gosu
COPY --from=tianon/gosu /gosu /usr/local/bin/

# give sudo rights to wheel group
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# install config
ARG NVIM_CONFIG_REPO=git@github.com:ojwenzel/astronvim_config.git
RUN --mount=type=ssh git clone --depth 1 ${NVIM_CONFIG_REPO} ~/.config/nvim

# setup entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# prepare workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# set nvim as command for container startup
CMD ["nvim", "/workspace"]

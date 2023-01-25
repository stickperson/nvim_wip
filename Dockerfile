FROM alpine:edge
WORKDIR /root/.config/nvim/
RUN apk add git lazygit neovim ripgrep alpine-sdk --update

# █▄░█ █▀▀ █▀█ █░█ █ █▀▄▀█
# █░▀█ ██▄ █▄█ ▀▄▀ █ █░▀░█

FROM alpine as builder

ARG BUILD_DEPS="autoconf automake cmake curl g++ gettext gettext-dev git libtool make ninja openssl pkgconfig unzip binutils wget"
ARG TARGET=nightly

RUN apk add --no-cache ${BUILD_DEPS} && \
  git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
  git fetch --all --tags -f && \
  git checkout ${TARGET} && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/ && \
  make install && \
  strip /usr/local/bin/nvim

FROM alpine
COPY --from=builder /usr/local /usr/local/
RUN true # see: https://github.com/moby/moby/issues/37965
# Required shared libraries
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/
RUN true
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/
RUN true
COPY --from=builder /usr/lib/libintl.so.8 /usr/lib/

# █▀▄ █▀▀ █▀█ █▀▀ █▄░█ █▀▄ █▀▀ █▄░█ █▀▀ █ █▀▀ █▀
# █▄▀ ██▄ █▀▀ ██▄ █░▀█ █▄▀ ██▄ █░▀█ █▄▄ █ ██▄ ▄█

RUN apk update && apk add --no-interactive git bash curl clang

# █ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░ █▀▀ █▀█
# █ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄ ██▄ █▀▄

COPY ./utils/installer/install.sh install.sh

RUN chmod u+x ./install.sh && ./install.sh

SHELL ["bash"]
CMD ["/root/.local/bin/cvim"]

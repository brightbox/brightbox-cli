FROM mcr.microsoft.com/devcontainers/ruby:2-3.4-trixie

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libncurses-dev \
    libyaml-dev \
    libffi-dev \
    libgdbm-dev \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Switch to vscode user
USER vscode

# Install OpenSSL 1.1.1w locally
RUN mkdir -p /home/vscode/.openssl_src \
    && cd /home/vscode/.openssl_src \
    && wget -q https://www.openssl.org/source/openssl-1.1.1w.tar.gz \
    && tar -zxf openssl-1.1.1w.tar.gz \
    && cd openssl-1.1.1w \
    && ./config --prefix=/home/vscode/.openssl/1.1.1w --openssldir=/home/vscode/.openssl/1.1.1w \
    && make \
    && make install \
    && cd .. \
    && rm -rf /home/vscode/.openssl_src

# Link system certificates
RUN rmdir /home/vscode/.openssl/1.1.1w/certs \
    && ln -s /etc/ssl/certs /home/vscode/.openssl/1.1.1w/certs \
    && ln -s /etc/ssl/certs/ca-certificates.crt /home/vscode/.openssl/1.1.1w/cert.pem

# Update RVM
USER root
SHELL ["/bin/bash", "-lc"]
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && rvm get master

# Install Rubies
USER vscode
RUN git config --global --add safe.directory /usr/local/rvm/repos/ruby
ENV RUBY_CFLAGS="-Wno-error=implicit-function-declaration"
RUN rvm install 2.7 --disable-binary --with-openssl-dir=/home/vscode/.openssl/1.1.1w
RUN rvm install 3.0 --disable-binary --with-openssl-dir=/home/vscode/.openssl/1.1.1w
RUN rvm install 3.1.6 --disable-binary
RUN rvm install 3.2.4 --disable-binary
RUN rvm install 3.3.1 --disable-binary

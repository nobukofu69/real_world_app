FROM ubuntu:20.04

# タイムゾーンの設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ディレクトリの作成
RUN mkdir /myapp

# 必要なパッケージのインストール
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libreadline-dev \
    libpq-dev zlib1g-dev nodejs npm yarn libmysqlclient-dev  \
    mysql-client curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Rubyのインストール
WORKDIR /tmp
RUN curl -O https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.6.tar.gz && \
    tar -xzvf ruby-3.0.6.tar.gz && \
    cd ruby-3.0.6 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-3.0.6 ruby-3.0.6.tar.gz && \
    gem install bundler

# 作業ディレクトリの設定
WORKDIR /myapp

# ホストのGemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerの実行
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

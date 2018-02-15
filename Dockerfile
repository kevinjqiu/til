FROM starefossen/ruby-node:2-8-alpine
MAINTAINER kevin@idempotent.ca
COPY ["Gemfile", "/tmp/Gemfile"]
COPY ["package.json", "/tmp/package.json"]
RUN mkdir /til && apk add --update libffi-dev make ruby-dev alpine-sdk && gem install ffi -v '1.9.18' && cd /tmp && bundle install && npm install && apk del alpine-sdk
WORKDIR /til
VOLUME /til

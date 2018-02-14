FROM starefossen/ruby-node:2-8-alpine
MAINTAINER kevin@idempotent.ca
RUN apk add --update libffi-dev make ruby-dev alpine-sdk
COPY . /til/
WORKDIR /til
RUN gem install ffi -v '1.9.18' \
    && bundle install \
    && npm install
VOLUME /til

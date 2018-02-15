FROM starefossen/ruby-node:2-8-alpine
MAINTAINER kevin@idempotent.ca
RUN mkdir /til && apk add --update libffi-dev make ruby-dev alpine-sdk && gem install ffi -v '1.9.18'
WORKDIR /til
VOLUME /til

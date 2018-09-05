FROM ruby:2.5.0-alpine3.7

RUN apk --no-cache add postgresql-dev postgresql-libs postgresql-client less

WORKDIR /koans
COPY Gemfile ./
COPY Gemfile.lock ./
RUN apk --no-cache add alpine-sdk && bundle install && apk del alpine-sdk

ADD . /koans

ENTRYPOINT ["/koans/wait-and-start.sh"]

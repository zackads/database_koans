FROM python:3-alpine

RUN apk --no-cache add postgresql-dev postgresql-libs postgresql-client less alpine-sdk && pip install pgcli && apk del alpine-sdk

ADD ./wait.sh /bin/start-workshop

ENTRYPOINT ["/bin/start-workshop"]

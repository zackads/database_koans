FROM python:2.7.15-alpine

RUN apk --no-cache add postgresql-dev postgresql-libs postgresql-client less alpine-sdk && pip install pgcli==1.10.3 && apk del alpine-sdk

ADD ./wait.sh /bin/start-workshop

ENTRYPOINT ["/bin/start-workshop"]

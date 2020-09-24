FROM alpine:latest

RUN apk add erlang-dev git
RUN mkdir /app
WORKDIR /app
CMD [ "/app/rebar3", "release" ]

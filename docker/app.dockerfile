FROM alpine:latest

RUN apk add erlang
RUN mkdir /app
COPY _build/default/rel/brick_announce/ /app/
RUN mkdir /app/config
COPY config /app/config
WORKDIR /app

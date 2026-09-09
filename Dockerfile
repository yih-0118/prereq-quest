# Mission 05 - Docker
#
# Something in here is wrong. `docker build` will succeed, but
# `docker run` will not behave. Read the error, inspect this file,
# and fix it.
#
# Intended final behavior:
#   $ docker build -t prereq-quest .
#   $ docker run --rm prereq-quest
#   hello, world
#   42

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates build-essential \
    && rm -rf /var/lib/apt/lists/*

# Built from source (rather than a prebuilt release archive) so this
# works the same on amd64 and arm64 hosts alike. It's a small C program;
# this takes a few seconds.
ARG JANET_VERSION=v1.42.0
RUN curl -fsSL -o /tmp/janet-src.tar.gz \
        "https://github.com/janet-lang/janet/archive/refs/tags/${JANET_VERSION}.tar.gz" \
    && mkdir -p /tmp/janet-src \
    && tar xzf /tmp/janet-src.tar.gz -C /tmp/janet-src --strip-components=1 \
    && make -C /tmp/janet-src -j"$(nproc)" \
    && make -C /tmp/janet-src install \
    && rm -rf /tmp/janet-src /tmp/janet-src.tar.gz

WORKDIR /quest

COPY app/main.janet ./main.janet

CMD ["janet", "main.janet" , "world"]

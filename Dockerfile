FROM docker.io/library/rust:1.61.0-bullseye AS builder
RUN cargo install --git https://github.com/getzola/zola --tag v0.16.3 --features libs/indexing-ja,libs/indexing-zh

from docker.io/library/debian:bullseye-slim
LABEL "maintainer"="Haru-T <htgeek.with.insight+com.github@googlemail.com>"

LABEL "com.github.actions.name"="Zola Deploy to Pages"
LABEL "com.github.actions.description"="Build and deploy a Zola site to GitHub Pages (ja/zh indexing available)"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="green"

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update && apt-get install -y --no-install-recommends git ca-certificates

COPY --from=builder /usr/local/cargo/bin/zola /usr/local/bin/zola
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

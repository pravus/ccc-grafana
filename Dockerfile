FROM alpine:3 AS builder

ENV GRAFANA_VERSION 9.5.2
ENV GRAFANA_SHA256 bd2c559e9ed17afa38c20b0ffffa6cb8024e7f8ca9fa9fab90f319060fa0ba0c

RUN apk --no-cache update \
 && apk --no-cache upgrade \
 && apk --no-cache add curl \
 && mkdir -p /opt

WORKDIR /opt

RUN curl -sSLO "https://dl.grafana.com/enterprise/release/grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz" \
 && echo "${GRAFANA_SHA256}  grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz" | sha256sum -cw - \
 && tar xzvf "grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz" \
 && mv "grafana-${GRAFANA_VERSION}" grafana


FROM alpine:3

RUN apk --no-cache update \
 && apk --no-cache upgrade \
 && apk --no-cache add ca-certificates gcompat libc6-compat \
 && ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2

COPY --from=builder /opt/grafana /opt/grafana

WORKDIR /opt/grafana

ENV ENV=/root/.ashrc
ENV PATH /opt/grafana/bin:$PATH

COPY entrypoint /
COPY root /root

ENTRYPOINT ["/entrypoint"]

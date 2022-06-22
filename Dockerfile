FROM alpine:3 AS builder

ENV GRAFANA_VERSION 9.0.1

RUN apk --no-cache update \
 && apk --no-cache upgrade \
 && apk --no-cache add curl \
 && mkdir -p /opt

WORKDIR /opt

RUN curl -sSLO "https://dl.grafana.com/enterprise/release/grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz" \
 && tar xzvf "grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz" \
 && mv "grafana-${GRAFANA_VERSION}" grafana


FROM alpine:3

RUN apk --no-cache update \
 && apk --no-cache upgrade \
 && apk --no-cache add ca-certificates

COPY --from=builder /opt/grafana /opt/grafana

WORKDIR /opt/grafana

ENV PATH /opt/grafana:$PATH

ENTRYPOINT ["/opt/grafana/grafana"]

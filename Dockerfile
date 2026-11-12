ARG BASE=ghcr.io/cloudnative-pg/postgresql:18-minimal-trixie
FROM $BASE AS builder

ARG PG_MAJOR
ARG TIMESCALE_VERSION

USER 0

RUN apt update && \
    apt install -y wget lsb-release

RUN echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/timescaledb.list && \
    wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg

RUN apt update && \
    apt install -y --no-install-recommends timescaledb-2-${TIMESCALE_VERSION}-postgresql-${PG_MAJOR}

FROM scratch

ARG PG_MAJOR
ARG TIMESCALE_VERSION

# licenses
COPY --from=builder /usr/share/doc/timescaledb-2-${TIMESCALE_VERSION}-postgresql-${PG_MAJOR}/copyright /licenses/timescaledb-2-${TIMESCALE_VERSION}-postgresql-${PG_MAJOR}/

# libraries
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/timescaledb* /lib/

# share
COPY --from=builder /usr/share/postgresql/${PG_MAJOR}/extension/timescaledb* /share/extension/

USER 65532:65532

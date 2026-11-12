# cloudnative-pg-timescaledb

[![build](https://github.com/vaaripa/cloudnative-pg-timescaledb/actions/workflows/build.yaml/badge.svg)](https://github.com/vaaripa/cloudnative-pg-timescaledb/actions/workflows/build.yaml)

TimescaleDB **Community Edition** packaged as a CloudNativePG [image volume extension](https://cloudnative-pg.io/docs/current/imagevolume_extensions/). The image is not runnable on its own — CloudNativePG mounts it read-only into the PostgreSQL pods via `.spec.postgresql.extensions`.

CloudNativePG publishes the same thing for the Apache 2 edition ([`timescaledb-oss`](https://github.com/cloudnative-pg/postgres-extensions-containers)). This one is the TSL build, for the features that edition leaves out — compression, continuous aggregate policies, retention policies.

Unofficial build, not affiliated with TigerData or the CloudNativePG project. It repackages unmodified upstream Debian packages from TigerData's packagecloud repository.

## Images

Images are available at [ghcr.io/vaaripa/cloudnative-pg-timescaledb](https://github.com/vaaripa/cloudnative-pg-timescaledb/pkgs/container/cloudnative-pg-timescaledb). Tags are `<timescale_version>-<pg_major>-<distro>` and `sha-<commit>`, for amd64 and arm64.

## Requirements

PostgreSQL 18+, CloudNativePG 1.27+, Kubernetes 1.35+ (or 1.33/1.34 with the `ImageVolume` feature gate), containerd ≥ 2.1.0 or CRI-O ≥ 1.31. The image's PostgreSQL major must match the cluster's.

TimescaleDB must be in `shared_preload_libraries` on the cluster — `CREATE EXTENSION` fails without it.

## Licensing

This repo's files: Apache 2.0. The image contains TimescaleDB under the [Timescale License](https://github.com/timescale/timescaledb/blob/main/tsl/LICENSE-TIMESCALE) and [Apache 2.0](https://github.com/timescale/timescaledb/blob/main/LICENSE-APACHE); the upstream copyright file ships in the image under `/licenses/`.

The TSL allows free use, modification and redistribution of unmodified binaries. It does not allow offering TimescaleDB Community Edition to third parties as a hosted or managed database service.

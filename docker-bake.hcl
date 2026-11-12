variable "GITHUB_REPOSITORY" {
  default = ""
  validation {
    condition = GITHUB_REPOSITORY != ""
    error_message = "GITHUB_REPOSITORY must be set"
  }
}

variable "GITHUB_SHA" {
  default = ""
  validation {
    condition = GITHUB_SHA != ""
    error_message = "GITHUB_SHA must be set"
  }
}

target "default" {
  matrix = {
    item = [
      { pg_major = "18", timescale_version = "2.32.0", distro = "trixie" }
    ]
  }

  name = sanitize("${item.pg_major}-${item.timescale_version}")
  dockerfile = "Dockerfile"
  context = "."
  args = {
    BASE = get_base_image(item.pg_major, item.distro)
    PG_MAJOR = item.pg_major
    TIMESCALE_VERSION = item.timescale_version
  }
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY}:${item.timescale_version}-${item.pg_major}-${item.distro}",
    "ghcr.io/${GITHUB_REPOSITORY}:sha-${GITHUB_SHA}"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/${GITHUB_REPOSITORY}"
    "org.opencontainers.image.revision" = GITHUB_SHA
    "org.opencontainers.image.licenses" = "Apache-2.0 AND PostgreSQL AND LicenseRef-Timescale"
    "io.cloudnativepg.image.base.name" = "${get_base_image(item.pg_major, item.distro)}",
    "io.cloudnativepg.image.sql.version" = item.timescale_version
  }
  annotations = [
    "index,manifest:org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY}",
    "index,manifest:org.opencontainers.image.revision=${GITHUB_SHA}",
    "index,manifest:org.opencontainers.image.licenses=Apache-2.0 AND PostgreSQL AND LicenseRef-Timescale",
    "index,manifest:io.cloudnativepg.image.base.name=${get_base_image(item.pg_major, item.distro)}",
    "index,manifest:io.cloudnativepg.image.sql.version=${item.timescale_version}",
  ]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

function "get_base_image" {
  params = [ pg_major, distro ]
  result = "ghcr.io/cloudnative-pg/postgresql:${pg_major}-minimal-${distro}"
}

variable "IMAGE_NAME" {}
variable "COMMIT_SHA" {}
variable "TARGETARCH" {
  default = "amd64"
}
variable "PG_VERSION" {
  default = 17
}

target "default" {
  context    = "."
  dockerfile = "Dockerfile"
  tags = [
    "${IMAGE_NAME}:${COMMIT_SHA}",
    "${IMAGE_NAME}:latest",
  ]
  args = {
    PG_VERSION     = "${PG_VERSION}"
    TARGETPLATFORM = "linux/${TARGETARCH}"
  }
  platforms = ["linux/amd64", "linux/arm64"]
}

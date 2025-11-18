terraform {
  required_providers {
    tofusoup = {
      source = "provide-io/tofusoup"
    }
  }
}

provider "tofusoup" {}

data "tofusoup_provider_info" "aws" {
  namespace = "hashicorp"
  name     = "aws"
  registry = "terraform"
}

output "aws_latest_version" {
  value = data.tofusoup_provider_info.aws.latest_version
}

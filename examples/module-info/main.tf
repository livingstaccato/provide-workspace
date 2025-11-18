terraform {
  required_providers {
    tofusoup = {
      source = "provide-io/tofusoup"
    }
  }
}

provider "tofusoup" {}

data "tofusoup_module_info" "vpc" {
  namespace       = "terraform-aws-modules"
  name           = "vpc"
  target_provider = "aws"
  registry       = "terraform"
}

output "vpc_version" {
  value = data.tofusoup_module_info.vpc.version
}

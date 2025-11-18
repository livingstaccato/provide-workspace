terraform {
  required_providers {
    tofusoup = {
      source = "provide-io/tofusoup"
    }
  }
}

provider "tofusoup" {}

data "tofusoup_state_info" "current" {
  state_path = "${path.module}/terraform.tfstate"
}

output "tf_version" {
  value = data.tofusoup_state_info.current.terraform_version
}

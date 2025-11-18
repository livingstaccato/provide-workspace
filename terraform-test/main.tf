# Terraform configuration using all tofusoup provider data sources
# This demonstrates each of the 9 available data sources

# 1. tofusoup_module_info - Get information about a specific module
data "tofusoup_module_info" "security_group" {
  namespace       = "terraform-aws-modules"
  name           = "security-group"
  target_provider = "aws"
  registry       = "terraform"
}

# 2. tofusoup_module_search - Search for modules matching a query
data "tofusoup_module_search" "kubernetes_modules" {
  query    = "kubernetes cluster"
  limit    = 15
  registry = "terraform"
}

# 3. tofusoup_module_versions - Get all versions of a specific module
data "tofusoup_module_versions" "eks_module" {
  namespace       = "terraform-aws-modules"
  name           = "eks"
  target_provider = "aws"
  registry       = "terraform"
}

# 4. tofusoup_provider_info - Get information about a specific provider
data "tofusoup_provider_info" "google_cloud" {
  namespace = "hashicorp"
  name     = "google"
  registry = "terraform"
}

# 5. tofusoup_provider_versions - Get all versions of a specific provider
data "tofusoup_provider_versions" "azurerm_provider" {
  namespace = "hashicorp"
  name     = "azurerm"
  registry = "terraform"
}

# 6. tofusoup_registry_search - Search across both modules and providers
data "tofusoup_registry_search" "networking_resources" {
  query         = "network security"
  resource_type = "modules"
  limit         = 25
  registry      = "terraform"
}

# 7. tofusoup_state_info - Get metadata about a Terraform state file
data "tofusoup_state_info" "current_state" {
  state_path = "${path.module}/dummy.tfstate"
}

# 8. tofusoup_state_outputs - Read outputs from a Terraform state file
data "tofusoup_state_outputs" "state_outputs" {
  state_path  = "${path.module}/dummy.tfstate"
  filter_name = "instance_ip"
}

# 9. tofusoup_state_resources - Query resources in a Terraform state file
data "tofusoup_state_resources" "managed_resources" {
  state_path  = "${path.module}/dummy.tfstate"
  filter_mode = "managed"
  filter_type = "aws_instance"
}

# Output examples to demonstrate the data sources are working
output "module_info_description" {
  description = "Description of the security-group module"
  value       = data.tofusoup_module_info.security_group.description
}

output "module_search_count" {
  description = "Number of kubernetes modules found"
  value       = data.tofusoup_module_search.kubernetes_modules.result_count
}

output "eks_version_count" {
  description = "Number of versions available for EKS module"
  value       = data.tofusoup_module_versions.eks_module.version_count
}

output "google_provider_latest" {
  description = "Latest version of Google Cloud provider"
  value       = data.tofusoup_provider_info.google_cloud.latest_version
}

output "azurerm_version_count" {
  description = "Number of Azure RM provider versions"
  value       = data.tofusoup_provider_versions.azurerm_provider.version_count
}

output "registry_search_results" {
  description = "Total results from networking security search"
  value       = data.tofusoup_registry_search.networking_resources.result_count
}

output "state_terraform_version" {
  description = "Terraform version used in state file"
  value       = data.tofusoup_state_info.current_state.terraform_version
}

output "state_outputs_count" {
  description = "Number of outputs in state file"
  value       = data.tofusoup_state_outputs.state_outputs.output_count
}

output "state_managed_resources" {
  description = "Number of managed resources in state"
  value       = data.tofusoup_state_resources.managed_resources.resource_count
}

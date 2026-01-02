# Tofusoup Provider Testing

This directory contains a comprehensive test configuration for the `provide-io/tofusoup` Terraform provider.

## Overview

The tofusoup provider is a Terraform provider that allows you to query information from Terraform and OpenTofu registries, as well as inspect Terraform state files. This configuration demonstrates all 9 available data sources.

## Provider Information

- **Source**: `provide-io/tofusoup`
- **Registry**: https://registry.terraform.io/providers/provide-io/tofusoup/latest
- **Version Used**: v0.0.1

## Data Sources Demonstrated

### Registry Query Data Sources

1. **tofusoup_module_info** - Retrieves detailed information about a specific module
   - Example: AWS Security Group module
   - Returns: description, downloads, version, owner, source URL, etc.

2. **tofusoup_module_search** - Searches for modules matching a query string
   - Example: Search for "kubernetes cluster" modules
   - Returns: List of matching modules with metadata

3. **tofusoup_module_versions** - Lists all available versions of a specific module
   - Example: All versions of the AWS EKS module
   - Returns: Version history with inputs, outputs, and resources

4. **tofusoup_provider_info** - Gets information about a specific provider
   - Example: Google Cloud provider details
   - Returns: Latest version, downloads, description, source URL

5. **tofusoup_provider_versions** - Lists all versions of a specific provider
   - Example: All versions of Azure RM provider
   - Returns: Version list with supported platforms and protocols

6. **tofusoup_registry_search** - Searches across modules and/or providers
   - Example: Search for "network security" resources
   - Returns: Combined results from registry search

### State File Analysis Data Sources

7. **tofusoup_state_info** - Extracts metadata from a Terraform state file
   - Returns: Terraform version, serial, lineage, resource counts, file info

8. **tofusoup_state_outputs** - Reads outputs from a Terraform state file
   - Supports filtering by output name
   - Returns: Output values, types, and sensitivity flags

9. **tofusoup_state_resources** - Queries resources in a Terraform state file
   - Supports filtering by mode (managed/data), module, and type
   - Returns: Resource details including IDs, types, and instance counts

## Files

- `provider.tf` - Provider configuration
- `main.tf` - All 9 data source examples with outputs
- `dummy.tfstate` - Sample state file for state-related data sources
- `README.md` - This documentation

## Usage

### Prerequisites

- Terraform v1.10+ installed
- Internet connectivity for registry queries

### Running the Configuration

```bash
# Initialize Terraform and download the provider
terraform init

# Validate the configuration
terraform validate

# View the plan (all data sources will be queried)
terraform plan

# Apply to save outputs (no infrastructure changes)
terraform apply
```

## Test Results

Example run results (values may vary based on registry state):

<!-- BEGIN TEST RESULTS -->
- ✓ Module info: Terraform module to create AWS Security Group resources
- ✓ Module search: Found 15 kubernetes modules
- ✓ Module versions: Listed 299 versions of terraform-aws-modules/eks
- ✓ Provider info: Latest Google provider 7.14.1
- ✓ Provider versions: Listed 374 versions of hashicorp/azurerm
- ✓ Registry search: Found 20 networking security results
- ✓ State info: Terraform version 1.10.3
- ✓ State outputs: Extracted 1 outputs
- ✓ State resources: Found 1 managed resources
<!-- END TEST RESULTS -->

To refresh this section after running Terraform, use:

```bash
python scripts/update_readme_results.py
```

## Key Features Demonstrated

- **Registry Queries**: All registry-related data sources support both Terraform and OpenTofu registries via the `registry` parameter
- **State Analysis**: State data sources can inspect any valid Terraform state file (v4 format)
- **Filtering**: State outputs and resources support optional filters
- **Real-time Data**: Registry queries fetch live data from public registries
- **No Authentication Required**: All data sources work without credentials

## Notes

- The state file data sources read from `dummy.tfstate`, a sample state file created for testing
- Registry queries access public APIs and don't require authentication
- The configuration uses diverse examples not found in the official documentation
- All outputs demonstrate the successful execution of each data source

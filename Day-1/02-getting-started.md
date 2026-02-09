# Getting Started with Terraform

To get started with Terraform, it's important to understand some key terminology and concepts. Here are the fundamental terms and explanations.

## 1. Provider

A **provider** is a plugin for Terraform that defines and manages resources for a specific cloud or infrastructure platform.

**Examples of providers include**:
- **OCI (Oracle Cloud Infrastructure)** - `oracle/oci`
- **AWS (Amazon Web Services)** - `hashicorp/aws`
- **Azure (Microsoft Azure)** - `hashicorp/azurerm`
- **Google Cloud Platform** - `hashicorp/google`
- **Kubernetes** - `hashicorp/kubernetes`
- **VMware vSphere** - for on-premises virtualization
- And hundreds more in the Terraform Registry

**How it works**:
You configure providers in your Terraform code to interact with the desired infrastructure platform. The provider handles authentication and API calls to the platform.

**Example for OCI**:
```hcl
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  region = "us-ashburn-1"
  # Credentials from ~/.oci/config will be used
}
```

**Key Points**:
- Each provider is maintained by HashiCorp, the cloud vendor, or the community
- Providers must be downloaded before use (`terraform init` downloads them)
- You can use multiple providers in the same Terraform configuration
- Provider versions should be specified for consistency

## 2. Resource

A **resource** is a specific infrastructure component that you want to create and manage using Terraform.

**Resources can include**:
- **Compute**: Virtual machines, bare metal instances
- **Networking**: VCNs, subnets, route tables, security lists
- **Storage**: Object Storage buckets, Block Volumes, File Storage
- **Database**: Autonomous Database, DB Systems, MySQL
- **Security**: Vaults, keys, secrets, IAM policies
- **Load Balancing**: Load balancers, backend sets
- And much more

Each resource has:
- A **type** (e.g., `oci_core_instance` for Compute instances)
- A **name** (local identifier in your Terraform code)
- **Configuration parameters** that you define

**Example**:
```hcl
resource "oci_core_instance" "web_server" {
  # Type: oci_core_instance
  # Name: web_server
  
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "web-server-1"
  
  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }
  
  create_vnic_details {
    subnet_id = oci_core_subnet.public_subnet.id
  }
}
```

**Resource Naming Convention**:
- Format: `resource "RESOURCE_TYPE" "LOCAL_NAME"`
- Reference in code: `RESOURCE_TYPE.LOCAL_NAME.attribute`
- Example: `oci_core_instance.web_server.id`

## 3. Module

A **module** is a reusable and encapsulated unit of Terraform code.

**Purpose**:
Modules allow you to:
- Package infrastructure configurations
- Make code easier to maintain and share
- Reuse common patterns across projects
- Enforce standards and best practices
- Reduce code duplication

**Types of modules**:
1. **Root Module**: The main working directory where you run Terraform commands
2. **Child Modules**: Modules called by the root module or other modules
3. **Published Modules**: Modules shared via Terraform Registry or Git

**Module Sources**:
- Your own custom modules
- Terraform Registry (public and verified modules)
- Oracle's official OCI modules
- GitHub repositories
- Local file paths

**Example of using a module**:
```hcl
# Using a VCN module
module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.5.0"
  
  compartment_id = var.compartment_ocid
  region         = var.region
  vcn_name       = "production-vcn"
  vcn_cidr_block = "10.0.0.0/16"
}

# Reference module outputs
resource "oci_core_subnet" "app_subnet" {
  vcn_id = module.vcn.vcn_id
  # ... other configuration
}
```

**Benefits**:
- Write once, use many times
- Easier testing and validation
- Standardized infrastructure patterns
- Simplified complexity

## 4. Configuration File

Terraform uses **configuration files** (with `.tf` extension) to define the desired infrastructure state.

**These files specify**:
- Providers
- Resources
- Variables
- Outputs
- Data sources
- Modules
- Other settings

**Common file names and purposes**:
- `main.tf` - Primary configuration file (resources)
- `variables.tf` - Variable declarations
- `outputs.tf` - Output definitions
- `provider.tf` or `providers.tf` - Provider configurations
- `terraform.tfvars` - Variable values (not committed to Git if contains secrets)
- `versions.tf` - Terraform and provider version constraints

**Key Points**:
- Files can have any name ending in `.tf`
- Terraform reads all `.tf` files in a directory
- Order of files doesn't matter
- Use multiple files to organize your code logically

**Example file structure**:
```
project/
├── main.tf           # Main resources
├── variables.tf      # Variable declarations
├── outputs.tf        # Output values
├── provider.tf       # Provider configuration
├── terraform.tfvars  # Variable values
└── README.md         # Documentation
```

## 5. Variable

**Variables** in Terraform are placeholders for values that can be passed into your configurations.

**Purpose**:
They make your code:
- More flexible and reusable
- Environment-agnostic (dev, staging, prod)
- Easier to maintain
- Secure (sensitive values can be hidden)

**Variable Types**:
- `string` - Text values
- `number` - Numeric values
- `bool` - True/false values
- `list` - Ordered list of values
- `map` - Key-value pairs
- `object` - Complex structured data
- `tuple` - Fixed-length list with specific types

**Example**:
```hcl
# variables.tf
variable "compartment_ocid" {
  description = "The OCID of the compartment"
  type        = string
}

variable "instance_shape" {
  description = "The shape for compute instances"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# main.tf - Using variables
resource "oci_core_instance" "app_server" {
  compartment_id = var.compartment_ocid
  shape          = var.instance_shape
  display_name   = "${var.environment}-app-server"
}
```

**Ways to provide variable values**:
1. Command line: `terraform apply -var="compartment_ocid=ocid1.compartment..."`
2. Variable file: `terraform.tfvars` or `*.auto.tfvars`
3. Environment variables: `TF_VAR_compartment_ocid=ocid1...`
4. Default values in variable declaration
5. Interactive prompts (if no value provided)

## 6. Output

**Outputs** are values generated by Terraform after infrastructure has been created or updated.

**Purpose**:
- Display important information after provisioning
- Pass values to other Terraform configurations
- Share data between modules
- Provide information for scripts or automation
- Document infrastructure attributes

**Example**:
```hcl
# outputs.tf
output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = oci_core_instance.web_server.public_ip
}

output "instance_ocid" {
  description = "OCID of the created instance"
  value       = oci_core_instance.web_server.id
}

output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.main.id
  sensitive   = false
}

output "database_connection_string" {
  description = "Database connection string"
  value       = oci_database_autonomous_database.main.connection_strings
  sensitive   = true  # Won't show in console output
}
```

**Accessing outputs**:
```bash
# After terraform apply
terraform output instance_public_ip

# Get all outputs in JSON
terraform output -json

# Use in scripts
INSTANCE_IP=$(terraform output -raw instance_public_ip)
```

## 7. State File

Terraform maintains a **state file** (named `terraform.tfstate`) that keeps track of the current state of your infrastructure.

**Purpose**:
- Records what resources Terraform has created
- Maps configuration to real-world resources
- Tracks metadata and resource dependencies
- Improves performance (caching)
- Enables collaboration through remote state

**What's in the state file**:
- Resource OCIDs and attributes
- Resource dependencies
- Metadata about your infrastructure
- **⚠️ Sensitive data** (database passwords, private keys, etc.)

**Important points**:
- **Never manually edit** the state file
- **Never commit** state files to Git (contains sensitive data)
- Use `.gitignore` to exclude `*.tfstate` and `*.tfstate.backup`
- Use remote state for team collaboration
- State locking prevents concurrent modifications

**Remote State Backend Options for OCI**:
- **OCI Object Storage** (recommended for OCI projects)
- AWS S3
- Azure Blob Storage
- HashiCorp Terraform Cloud
- Terraform Enterprise

**Example remote state configuration (OCI Object Storage)**:
```hcl
terraform {
  backend "s3" {
    bucket   = "terraform-state-bucket"
    key      = "project/terraform.tfstate"
    region   = "us-ashburn-1"
    endpoint = "https://NAMESPACE.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

## 8. Plan

A Terraform **plan** is a preview of changes that Terraform will make to your infrastructure.

**What `terraform plan` does**:
1. Reads your configuration files
2. Reads the current state file
3. Queries the actual infrastructure (via APIs)
4. Compares desired state vs. current state
5. Generates an execution plan

**Plan Output Shows**:
- Resources to be **created** (+)
- Resources to be **modified** (~)
- Resources to be **destroyed** (-)
- Resources to be **replaced** (-/+)
- Resources that will remain **unchanged**

**Example plan output**:
```
Terraform will perform the following actions:

  # oci_core_instance.web_server will be created
  + resource "oci_core_instance" "web_server" {
      + id                  = (known after apply)
      + display_name        = "web-server"
      + shape               = "VM.Standard.E2.1.Micro"
      + public_ip           = (known after apply)
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

**Best Practice**:
- **Always run `terraform plan`** before `terraform apply`
- Review the plan carefully
- Save plans for auditing: `terraform plan -out=tfplan`
- Apply saved plans: `terraform apply tfplan`

## 9. Apply

The **`terraform apply`** command executes the changes specified in the plan.

**What it does**:
1. Generates a plan (unless you provide a saved plan)
2. Shows you what will change
3. Asks for confirmation (type "yes")
4. Creates, updates, or destroys resources
5. Updates the state file
6. Displays outputs

**Command variations**:
```bash
# Interactive (shows plan and asks for confirmation)
terraform apply

# Auto-approve (skip confirmation - use with caution!)
terraform apply -auto-approve

# Apply a saved plan
terraform plan -out=tfplan
terraform apply tfplan

# Apply with variable override
terraform apply -var="environment=production"
```

**During apply, Terraform**:
- Makes API calls to OCI
- Creates resources in the specified order (respects dependencies)
- Handles errors and retries
- Updates the state file
- Provides progress information

## 10. Workspace

**Workspaces** in Terraform are a way to manage multiple environments with separate state files.

**Common use cases**:
- Development, staging, and production environments
- Different regions or availability domains
- Different teams or projects
- Testing changes without affecting production

**Workspace commands**:
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete dev
```

**How it works**:
- Each workspace has its own state file
- Same configuration can be used across workspaces
- Use `terraform.workspace` to reference current workspace name

**Example**:
```hcl
resource "oci_core_instance" "app" {
  display_name = "${terraform.workspace}-app-server"
  shape        = terraform.workspace == "prod" ? "VM.Standard2.1" : "VM.Standard.E2.1.Micro"
}
```

**Workspace state files location**:
```
terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── staging/
│   └── terraform.tfstate
└── prod/
    └── terraform.tfstate
```

## 11. Remote Backend

A **remote backend** is a storage location for your Terraform state files that is not stored locally.

**Why use remote backend**:
- **Collaboration**: Multiple team members can work on the same infrastructure
- **State Locking**: Prevents concurrent modifications
- **Security**: Better access control and encryption
- **Reliability**: Backup and versioning of state files
- **CI/CD Integration**: Easier to automate deployments

**Popular remote backend options**:
- **OCI Object Storage** (recommended for OCI projects)
- AWS S3 + DynamoDB (for state locking)
- Azure Blob Storage
- Google Cloud Storage
- HashiCorp Terraform Cloud
- Terraform Enterprise
- Consul
- PostgreSQL

**Benefits of OCI Object Storage as backend**:
- Native OCI integration
- High durability and availability
- Supports versioning
- Free tier eligible
- Encryption at rest
- Access control via IAM policies

**Example - OCI Object Storage backend**:
```hcl
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "production/terraform.tfstate"
    region                      = "us-ashburn-1"
    endpoint                    = "https://NAMESPACE.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

## 12. Data Source

A **data source** allows Terraform to fetch information from existing resources or external systems.

**Purpose**:
- Query existing infrastructure
- Get information about OCI resources not managed by Terraform
- Retrieve computed values
- Reference resources created outside Terraform

**Example**:
```hcl
# Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get latest Oracle Linux image
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Use data source in resource
resource "oci_core_instance" "web" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  source_details {
    source_id = data.oci_core_images.oracle_linux.images[0].id
  }
}
```

## Summary of Key Terms

| Term | Purpose | Example |
|------|---------|---------|
| **Provider** | Connect to cloud platform | `provider "oci"` |
| **Resource** | Infrastructure to create | `oci_core_instance` |
| **Module** | Reusable code | VCN module |
| **Configuration** | Terraform files | `main.tf`, `variables.tf` |
| **Variable** | Input parameters | `var.compartment_ocid` |
| **Output** | Return values | Instance IP address |
| **State** | Current infrastructure state | `terraform.tfstate` |
| **Plan** | Preview of changes | `terraform plan` |
| **Apply** | Execute changes | `terraform apply` |
| **Workspace** | Separate environments | dev, staging, prod |
| **Backend** | Remote state storage | OCI Object Storage |
| **Data Source** | Query existing resources | Get availability domains |

---

These are the essential terms you'll encounter when working with Terraform. As you start using Terraform for your OCI infrastructure provisioning and management, you'll become more familiar with these concepts and how they fit together in your IaC workflows.

**Next Step**: Now that you understand the terminology, you're ready to install Terraform and start creating your first OCI resources!

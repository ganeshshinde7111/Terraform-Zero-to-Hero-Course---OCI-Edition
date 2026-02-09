# Day-1 Theory Notes - Terraform Zero to Hero (OCI Edition)

**Complete Reference Guide for Day 1**

---

## Table of Contents

1. [What is Infrastructure as Code (IaC)?](#1-what-is-infrastructure-as-code-iac)
2. [Why Terraform?](#2-why-terraform)
3. [Terraform Core Concepts](#3-terraform-core-concepts)
4. [Installing Terraform](#4-installing-terraform)
5. [Setting Up OCI for Terraform](#5-setting-up-oci-for-terraform)
6. [Writing Your First Terraform Code](#6-writing-your-first-terraform-code)
7. [Terraform Lifecycle](#7-terraform-lifecycle)
8. [Terraform State File](#8-terraform-state-file)
9. [Best Practices](#9-best-practices)
10. [Common Issues and Solutions](#10-common-issues-and-solutions)

---

## 1. What is Infrastructure as Code (IaC)?

### The Problem Before IaC

Before Infrastructure as Code, managing cloud infrastructure was:

1. **Manual and Time-Consuming**
   - System admins configured servers manually through web consoles
   - Click-through multiple screens for each resource
   - Example: Creating an Object Storage bucket manually in OCI Console
   - For 100 requests = 100 × 2 minutes = 200 minutes of manual work

2. **Error-Prone**
   - Human errors during manual configuration
   - Inconsistencies between environments (dev vs prod)
   - No way to ensure exact replication

3. **Not Version Controlled**
   - Infrastructure configurations weren't tracked
   - Difficult to know who changed what and when
   - No rollback capability
   - Changes not reviewable

4. **Documentation Heavy**
   - Relied on written documentation (Word docs, wikis)
   - Documentation quickly became outdated
   - Knowledge silos (only certain people knew how things work)

5. **Slow Provisioning**
   - Multiple manual steps to provision resources
   - Delays in project delivery
   - Hard to scale quickly

### The IaC Solution

**Infrastructure as Code (IaC)** treats infrastructure the same way developers treat application code:

- **Write infrastructure in code** (not manual clicks)
- **Version control** your infrastructure (Git)
- **Review changes** through pull requests
- **Automate provisioning** (create 100 resources in minutes)
- **Consistency** across environments
- **Reusability** through modules
- **Documentation** built into the code itself

### Popular IaC Tools

| Tool | Provider | Type |
|------|----------|------|
| **Terraform** | HashiCorp | Multi-cloud, universal |
| **CloudFormation** | AWS | AWS-specific |
| **Azure Resource Manager** | Microsoft | Azure-specific |
| **OCI Resource Manager** | Oracle | OCI-specific (uses Terraform) |
| **Cloud Deployment Manager** | Google Cloud | GCP-specific |
| **Heat Templates** | OpenStack | OpenStack-specific |
| **Pulumi** | Pulumi Corp | Multi-cloud (uses programming languages) |

---

## 2. Why Terraform?

### The Universal Approach Problem

Imagine you're a DevOps engineer:
- Company A uses **OCI** → Need to learn OCI Resource Manager/Terraform
- Project B uses **AWS** → Need to learn CloudFormation
- Move to Company C using **Azure** → Need to learn ARM templates
- Startup D uses **GCP** → Need to learn Cloud Deployment Manager

**Result**: You need to learn 4+ different IaC tools with different syntaxes!

### Terraform's Solution: One Tool for All Clouds

**Terraform provides a universal approach**:
- ✅ Learn **one tool** (Terraform)
- ✅ Use **one language** (HCL)
- ✅ Work with **any cloud provider**
- ✅ Same concepts across all platforms

**Example**:
```hcl
# For OCI
resource "oci_core_instance" "web" {
  shape = "VM.Standard.E2.1.Micro"
}

# For AWS - same structure, different provider
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}

# For Azure - same structure, different provider
resource "azurerm_virtual_machine" "web" {
  vm_size = "Standard_B1s"
}
```

### Key Reasons Why Terraform

#### 1. Multi-Cloud Support ⭐⭐⭐

- Work with OCI, AWS, Azure, GCP using the same tool
- Hybrid cloud strategies (on-prem + cloud)
- Avoid vendor lock-in
- Skills transfer between clouds

#### 2. Large Ecosystem

- **3,000+** providers in Terraform Registry
- **Official OCI provider** maintained by Oracle
- Community-contributed modules
- Pre-built solutions for common patterns
- Active development and updates

#### 3. Declarative Syntax

**Declarative** (Terraform):
```hcl
# You say WHAT you want
resource "oci_core_instance" "web" {
  shape = "VM.Standard.E2.1.Micro"
}
# Terraform figures out HOW to create it
```

**Imperative** (Traditional scripting):
```python
# You say HOW to create it step-by-step
instance = create_instance()
instance.set_shape("VM.Standard.E2.1.Micro")
instance.configure_network()
instance.start()
```

**Benefits**:
- Easier to read and understand
- Less code to maintain
- Focus on outcome, not process

#### 4. State Management

Terraform maintains a **state file** that:
- Tracks all resources it has created
- Knows the difference between desired and actual state
- Enables intelligent updates (only change what's needed)
- Prevents accidental deletions
- Supports team collaboration through remote state

#### 5. Plan Before Apply (Safety)

```bash
terraform plan   # Preview changes (dry run)
terraform apply  # Execute changes
```

**Benefits**:
- See exactly what will change before it happens
- Catch mistakes before they affect production
- Review and approval workflow
- No surprises

#### 6. Strong Community Support

- **Massive user base** worldwide
- Active forums and discussions
- Stack Overflow support
- Thousands of blog posts and tutorials
- HashiCorp Learn platform
- Regular conferences (HashiConf)

#### 7. Integration with DevOps Tools

Terraform works seamlessly with:
- **Version Control**: Git, GitHub, GitLab, Bitbucket
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions, OCI DevOps
- **Configuration Management**: Ansible, Chef, Puppet
- **Containers**: Docker, Kubernetes
- **Monitoring**: Prometheus, Grafana, Datadog
- **Secret Management**: HashiCorp Vault, OCI Vault

#### 8. HCL Language (Human-Readable)

**HashiCorp Configuration Language (HCL)**:
- Designed specifically for infrastructure
- Easy to read and write
- Supports comments, variables, functions
- JSON-compatible
- Built-in functions for common tasks

**Example**:
```hcl
# Easy to understand
resource "oci_core_vcn" "main" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "main-vcn"
  
  # Clear tagging
  freeform_tags = {
    Environment = "Production"
    Team        = "DevOps"
    ManagedBy   = "Terraform"
  }
}
```

#### 9. API as Code Concept

**How it works**:
1. You write infrastructure in HCL
2. Terraform translates HCL → Cloud Provider API calls
3. For OCI: HCL → OCI REST API calls
4. Terraform handles authentication, retries, error handling

**You don't need to**:
- Learn each cloud provider's API
- Write API calls manually
- Handle error retries
- Manage authentication tokens

#### 10. Industry Standard

- **Most popular** IaC tool (by far)
- **High demand** in job market
- Expected skill for DevOps/Cloud roles
- Used by Fortune 500 companies
- Proven at scale (manage 100,000+ resources)

### Terraform vs Alternatives

| Feature | Terraform | CloudFormation | ARM | Pulumi |
|---------|-----------|----------------|-----|--------|
| Multi-cloud | ✅ Yes | ❌ AWS only | ❌ Azure only | ✅ Yes |
| Language | HCL | JSON/YAML | JSON | Python/TS/Go |
| Community | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Learning Curve | Easy | Medium | Medium | Medium |
| State Management | ✅ Built-in | ✅ Built-in | ✅ Built-in | ✅ Built-in |
| Cost | Free (OSS) | Free | Free | Free/Paid |

### Why Terraform for OCI Specifically?

1. **Official Support**: Oracle maintains the OCI provider
2. **Comprehensive**: Supports all OCI services
3. **Well-Documented**: Extensive examples and docs
4. **Free Tier Compatible**: Works with OCI Free Tier
5. **Resource Manager Integration**: OCI Resource Manager uses Terraform
6. **Best Practices**: Oracle provides Terraform best practices for OCI

---

## 3. Terraform Core Concepts

### 3.1 Provider

**What**: Plugin that connects Terraform to a cloud platform

**For OCI**:
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
}
```

**Key Points**:
- Handles authentication
- Makes API calls to OCI
- Downloaded during `terraform init`
- Can specify version constraints

### 3.2 Resource

**What**: Infrastructure component you want to create

**Examples**:
```hcl
# Compute Instance
resource "oci_core_instance" "web_server" {
  shape          = "VM.Standard.E2.1.Micro"
  compartment_id = var.compartment_id
  # ... more configuration
}

# Object Storage Bucket
resource "oci_objectstorage_bucket" "data_bucket" {
  name           = "my-data-bucket"
  compartment_id = var.compartment_id
  # ... more configuration
}

# VCN
resource "oci_core_vcn" "main" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
}
```

**Naming**: `resource "TYPE" "NAME"`
- TYPE: e.g., `oci_core_instance`
- NAME: Your local identifier (e.g., `web_server`)

### 3.3 Data Source

**What**: Query existing resources or get information

**Examples**:
```hcl
# Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get latest Oracle Linux image
data "oci_core_images" "oracle_linux" {
  compartment_id   = var.compartment_ocid
  operating_system = "Oracle Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

# Use in resource
resource "oci_core_instance" "web" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  source_details {
    source_id = data.oci_core_images.oracle_linux.images[0].id
  }
}
```

### 3.4 Variable

**What**: Input parameters for your configuration

**Declaration** (variables.tf):
```hcl
variable "compartment_ocid" {
  description = "OCID of the compartment"
  type        = string
}

variable "instance_shape" {
  description = "Shape for compute instance"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}
```

**Usage**:
```hcl
resource "oci_core_instance" "app" {
  compartment_id = var.compartment_ocid
  shape          = var.instance_shape
  count          = var.instance_count
}
```

**Providing Values**:
1. terraform.tfvars file
2. Command line: `-var="compartment_ocid=ocid1..."`
3. Environment variables: `TF_VAR_compartment_ocid`
4. Interactive prompt

### 3.5 Output

**What**: Values to display after applying

```hcl
output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = oci_core_instance.web.public_ip
}

output "instance_ocid" {
  value = oci_core_instance.web.id
}
```

**View outputs**:
```bash
terraform output
terraform output instance_public_ip
terraform output -json
```

### 3.6 Module

**What**: Reusable collection of Terraform files

**Structure**:
```
modules/
└── compute-instance/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

**Using a module**:
```hcl
module "web_server" {
  source = "./modules/compute-instance"
  
  compartment_id = var.compartment_id
  shape          = "VM.Standard.E2.1.Micro"
  display_name   = "web-server"
}

# Access module outputs
output "web_server_ip" {
  value = module.web_server.public_ip
}
```

### 3.7 State File

**What**: terraform.tfstate - tracks your infrastructure

**Contains**:
- Resource OCIDs
- Resource attributes
- Dependencies
- Metadata

**Important**:
- ⚠️ Contains sensitive data
- ⚠️ Never manually edit
- ⚠️ Never commit to Git
- ✅ Use remote state for teams
- ✅ Enable state locking

### 3.8 Backend

**What**: Where state file is stored

**Local Backend** (default):
```hcl
# State stored in ./terraform.tfstate
```

**Remote Backend** (OCI Object Storage):
```hcl
terraform {
  backend "s3" {
    bucket   = "terraform-state"
    key      = "prod/terraform.tfstate"
    region   = "us-ashburn-1"
    endpoint = "https://NAMESPACE.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    # ... more configuration
  }
}
```

---

## 4. Installing Terraform

### Quick Installation by OS

**macOS (Homebrew)**:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Ubuntu/Debian**:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Windows**:
1. Download from https://developer.hashicorp.com/terraform/downloads
2. Extract terraform.exe
3. Add to PATH
4. Use Git Bash or PowerShell

**Verification**:
```bash
terraform --version
# Output: Terraform v1.6.x
```

### GitHub Codespaces (Cloud Option)

**Perfect for**:
- No local machine
- Limited resources
- Quick testing
- Learning

**Setup**:
1. Fork the repository
2. Create Codespace
3. Add Dev Container for Terraform
4. Add Dev Container for OCI CLI
5. Rebuild container

**Free**: 60 hours/month

---

## 5. Setting Up OCI for Terraform

### 5.1 OCI Account

**Create account**: https://www.oracle.com/cloud/free/

**Free Tier includes**:
- 2 Always-Free Compute instances
- 200 GB Block Storage
- 10 GB Object Storage
- Autonomous Database
- Load Balancer
- And more...

### 5.2 Gather Required Information

You need these OCIDs:

1. **Tenancy OCID**
   - Profile → Tenancy → Copy OCID
   - Format: `ocid1.tenancy.oc1..aaaaaa...`

2. **User OCID**
   - Profile → Username → Copy OCID
   - Format: `ocid1.user.oc1..aaaaaa...`

3. **Compartment OCID**
   - Identity & Security → Compartments
   - Or use Tenancy OCID for root compartment

4. **Region Identifier**
   - Examples: `us-ashburn-1`, `us-phoenix-1`, `uk-london-1`

### 5.3 Create API Keys

```bash
# Create directory
mkdir -p ~/.oci

# Generate private key
openssl genrsa -out ~/.oci/oci_api_key.pem 2048

# Set permissions
chmod 600 ~/.oci/oci_api_key.pem

# Generate public key
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

### 5.4 Upload Public Key to OCI

1. Profile → Username → API Keys
2. Add API Key
3. Paste public key content
4. Copy the **Fingerprint**

### 5.5 Configure OCI CLI

```bash
oci setup config
```

**Provide**:
- User OCID
- Tenancy OCID
- Region
- Path to private key

**Result**: Creates `~/.oci/config`

### 5.6 Test Connection

```bash
# Get namespace
oci os ns get

# List compartments
oci iam compartment list

# List availability domains
oci iam availability-domain list
```

---

## 6. Writing Your First Terraform Code

### File Structure

```
project/
├── provider.tf       # Provider configuration
├── variables.tf      # Variable declarations
├── terraform.tfvars  # Variable values (don't commit!)
├── main.tf           # Main resources
├── outputs.tf        # Output definitions
└── .gitignore        # Ignore sensitive files
```

### Minimal Example

**provider.tf**:
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
}
```

**variables.tf**:
```hcl
variable "compartment_ocid" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}
```

**main.tf**:
```hcl
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

output "availability_domain_name" {
  value = data.oci_identity_availability_domain.ad.name
}
```

**terraform.tfvars**:
```hcl
compartment_ocid = "ocid1.compartment.oc1..aaaaaaa..."
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaa..."
```

---

## 7. Terraform Lifecycle

### The Four Main Commands

#### 1. terraform init

**What it does**:
- Initializes the working directory
- Downloads provider plugins
- Sets up backend
- Creates `.terraform` directory

```bash
terraform init
```

**Output**:
```
Initializing the backend...
Initializing provider plugins...
- Finding oracle/oci versions matching ">= 5.0.0"...
- Installing oracle/oci v5.20.0...

Terraform has been successfully initialized!
```

**When to run**:
- First time in a new directory
- After adding new providers
- After changing backend configuration

#### 2. terraform plan

**What it does**:
- Creates execution plan
- Shows what will be created, changed, or destroyed
- Doesn't make any actual changes (dry run)

```bash
terraform plan
```

**Output Example**:
```
Terraform will perform the following actions:

  # oci_core_instance.web will be created
  + resource "oci_core_instance" "web" {
      + id                  = (known after apply)
      + display_name        = "web-server"
      + shape               = "VM.Standard.E2.1.Micro"
      + public_ip           = (known after apply)
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

**Symbols**:
- `+` = will be created
- `~` = will be modified
- `-` = will be destroyed
- `-/+` = will be replaced

**Save plan**:
```bash
terraform plan -out=tfplan
terraform apply tfplan  # Apply saved plan
```

#### 3. terraform apply

**What it does**:
- Executes the plan
- Creates/updates/destroys resources
- Updates state file
- Shows outputs

```bash
terraform apply
```

**Workflow**:
1. Shows plan
2. Asks for confirmation: `Enter a value: yes`
3. Makes API calls to OCI
4. Creates resources
5. Updates state
6. Displays outputs

**Auto-approve** (skip confirmation):
```bash
terraform apply -auto-approve
```

**⚠️ Use carefully!** Only in dev environments.

#### 4. terraform destroy

**What it does**:
- Destroys all managed resources
- Removes them from OCI
- Updates state file

```bash
terraform destroy
```

**Workflow**:
1. Shows what will be destroyed
2. Asks for confirmation: `Enter a value: yes`
3. Destroys resources in reverse dependency order

**Destroy specific resource**:
```bash
terraform destroy -target=oci_core_instance.web
```

### Complete Workflow

```bash
# 1. Write configuration files
# 2. Initialize
terraform init

# 3. Format code (optional)
terraform fmt

# 4. Validate syntax (optional)
terraform validate

# 5. Plan
terraform plan

# 6. Review plan carefully

# 7. Apply
terraform apply

# 8. Verify in OCI Console

# 9. Make changes if needed
# Edit .tf files
terraform plan
terraform apply

# 10. Destroy when done
terraform destroy
```

### Other Useful Commands

```bash
# Show current state
terraform show

# List resources in state
terraform state list

# View specific resource
terraform state show oci_core_instance.web

# View outputs
terraform output

# Refresh state (sync with actual infrastructure)
terraform refresh

# Import existing resource
terraform import oci_core_instance.web <instance-ocid>

# Format all .tf files
terraform fmt

# Validate configuration
terraform validate

# Create dependency graph
terraform graph | dot -Tpng > graph.png
```

---

## 8. Terraform State File

### What is State?

**terraform.tfstate**: JSON file tracking your infrastructure

**Contains**:
- Resource OCIDs and attributes
- Dependencies between resources
- Resource metadata
- Provider configuration
- **⚠️ SENSITIVE DATA** (passwords, private keys)

### Why State is Important

1. **Mapping**: Maps configuration to real resources
2. **Performance**: Caching (doesn't query OCI every time)
3. **Dependencies**: Tracks relationships between resources
4. **Collaboration**: Shared understanding of infrastructure
5. **Change Detection**: Knows what changed since last apply

### State File Example

```json
{
  "version": 4,
  "terraform_version": "1.6.0",
  "resources": [
    {
      "type": "oci_core_instance",
      "name": "web",
      "provider": "provider[\"registry.terraform.io/oracle/oci\"]",
      "instances": [
        {
          "attributes": {
            "id": "ocid1.instance.oc1.iad.anuwcl...",
            "display_name": "web-server",
            "public_ip": "129.213.45.67",
            "shape": "VM.Standard.E2.1.Micro"
          }
        }
      ]
    }
  ]
}
```

### ⚠️ Security Considerations

**NEVER**:
- ❌ Commit state files to Git
- ❌ Share state files via email
- ❌ Store in publicly accessible locations
- ❌ Manually edit state files

**ALWAYS**:
- ✅ Add `*.tfstate*` to .gitignore
- ✅ Use remote state for teams
- ✅ Enable state locking
- ✅ Encrypt state files
- ✅ Limit access to state storage

### Remote State (Recommended for Teams)

**OCI Object Storage Backend**:
```hcl
terraform {
  backend "s3" {
    bucket   = "terraform-state-bucket"
    key      = "production/terraform.tfstate"
    region   = "us-ashburn-1"
    endpoint = "https://NAMESPACE.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

**Benefits**:
- ✅ Shared access for team
- ✅ State locking (prevents conflicts)
- ✅ Versioning (rollback capability)
- ✅ Encryption at rest
- ✅ Backup and disaster recovery

---

## 9. Best Practices

### 9.1 Code Organization

```
project/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   └── prod/
├── modules/
│   ├── compute/
│   ├── networking/
│   └── database/
└── README.md
```

### 9.2 Naming Conventions

**Resources**:
```hcl
# Format: environment-purpose-resource
resource "oci_core_instance" "prod_web_server" {}
resource "oci_core_vcn" "prod_main_vcn" {}
```

**Variables**:
```hcl
# Use descriptive names
variable "instance_shape" {}          # ✅ Good
variable "shape" {}                   # ❌ Too generic
variable "prod_web_server_shape" {}   # ❌ Too specific
```

### 9.3 Version Control

**.gitignore**:
```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
.terraform.lock.hcl

# Sensitive files
*.tfvars
*.pem
.oci/

# OS
.DS_Store
Thumbs.db
```

**Commit messages**:
```
feat: add compute instance module
fix: correct security list rules
docs: update README with setup instructions
refactor: reorganize networking resources
```

### 9.4 Security

**✅ DO**:
- Use variables for sensitive data
- Store secrets in OCI Vault
- Use least privilege IAM policies
- Enable state encryption
- Regular security audits
- Use private subnets where possible

**❌ DON'T**:
- Hardcode credentials in .tf files
- Commit secrets to Git
- Use root compartment for everything
- Give excessive permissions
- Disable security features for convenience

### 9.5 Testing

**Always test changes**:
```bash
# 1. Validate syntax
terraform validate

# 2. Plan and review
terraform plan

# 3. Apply in dev first
terraform apply

# 4. Verify in OCI Console

# 5. Test application

# 6. Apply to staging

# 7. Finally apply to production
```

### 9.6 Documentation

**README.md example**:
```markdown
# Project Name

## Description
Brief description of what this Terraform project does.

## Prerequisites
- Terraform >= 1.6.0
- OCI CLI configured
- Valid OCI credentials

## Quick Start
\`\`\`bash
terraform init
terraform plan
terraform apply
\`\`\`

## Variables
| Name | Description | Type | Default |
|------|-------------|------|---------|
| compartment_ocid | OCID of compartment | string | - |

## Outputs
- `instance_ip` - Public IP of instance
```

### 9.7 Cost Management

**Tag resources**:
```hcl
freeform_tags = {
  "Environment" = "Production"
  "CostCenter"  = "Engineering"
  "Owner"       = "DevOps-Team"
  "ManagedBy"   = "Terraform"
}
```

**Destroy test resources**:
```bash
# Always destroy after testing
terraform destroy
```

**Use Free Tier shapes**:
```hcl
shape = "VM.Standard.E2.1.Micro"  # Always Free
```

---

## 10. Common Issues and Solutions

### Issue 1: "Service error: NotAuthenticated"

**Error**:
```
Error: Service error:NotAuthenticated. The required information to complete
authentication was not provided or was incorrect.
```

**Causes**:
- Wrong OCIDs
- Wrong fingerprint
- Private key doesn't match public key
- Wrong key file path

**Solutions**:
```bash
# 1. Verify config
cat ~/.oci/config

# 2. Check fingerprint in OCI Console
# Profile → Username → API Keys

# 3. Verify key file exists
ls -la ~/.oci/oci_api_key.pem

# 4. Check permissions
chmod 600 ~/.oci/oci_api_key.pem

# 5. Test OCI CLI
oci os ns get
```

### Issue 2: "Error: No subnet specified"

**Error**:
```
Error: "subnet_id" is required
```

**Cause**: Missing VCN and subnet configuration

**Solution**: Create VCN and subnet first:
```hcl
resource "oci_core_vcn" "main" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
}

resource "oci_core_subnet" "public" {
  vcn_id         = oci_core_vcn.main.id
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
}

resource "oci_core_instance" "web" {
  # ... other config
  create_vnic_details {
    subnet_id = oci_core_subnet.public.id
  }
}
```

### Issue 3: "Image not found"

**Error**:
```
Error: The specified image was not found
```

**Cause**: Image OCID doesn't exist in your region

**Solution**: Use data source to get latest image:
```hcl
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "web" {
  source_details {
    source_id = data.oci_core_images.oracle_linux.images[0].id
  }
}
```

### Issue 4: "Limit exceeded"

**Error**:
```
Error: LimitExceeded. You have reached your service limit
```

**Cause**: Hit Free Tier or account limits

**Solutions**:
```bash
# 1. Check existing resources
oci compute instance list --compartment-id <ocid>

# 2. Delete unused resources
terraform destroy

# 3. Request limit increase (paid accounts)
# OCI Console → Governance → Limits, Quotas and Usage
```

### Issue 5: "terraform init" fails

**Error**:
```
Error: Failed to install provider
```

**Solutions**:
```bash
# 1. Check internet connection
ping registry.terraform.io

# 2. Clear .terraform directory
rm -rf .terraform .terraform.lock.hcl

# 3. Reinitialize
terraform init

# 4. Use specific version
# In provider.tf:
version = "= 5.20.0"
```

### Issue 6: State file locked

**Error**:
```
Error: Error locking state: state locked by another process
```

**Cause**: Another terraform process is running, or previous run didn't clean up

**Solution**:
```bash
# Force unlock (use carefully!)
terraform force-unlock <lock-id>

# Or wait for other process to complete
```

---

## Summary

### What We Learned in Day 1

✅ **Infrastructure as Code concepts**
✅ **Why Terraform is the industry standard**
✅ **Core Terraform concepts** (providers, resources, state)
✅ **How to install Terraform**
✅ **How to set up OCI authentication**
✅ **How to write first Terraform code**
✅ **Terraform lifecycle** (init, plan, apply, destroy)
✅ **State file basics and importance**
✅ **Best practices and security**
✅ **Common issues and troubleshooting**

### Key Takeaways

1. **Terraform = Universal IaC tool** for all clouds
2. **HCL = Easy-to-learn** configuration language
3. **State file = Critical** for tracking infrastructure
4. **Plan before apply = Best practice** for safety
5. **Always destroy test resources** to avoid charges

### Next Steps

**Day 2**: Advanced Terraform Configuration
- Variables and data types
- Outputs and dependencies
- Conditional expressions
- Built-in functions
- Debugging techniques

**Day 3**: Modules and Reusability
- Creating custom modules
- Using public modules
- Module best practices
- Terraform Registry

**Day 4**: Collaboration and State Management
- Remote state backends
- State locking
- Git workflows
- Team collaboration

**Day 5-7**: Advanced topics, provisioners, workspaces, security, and production readiness

---

## Quick Reference Commands

```bash
# Initialization
terraform init                 # Initialize directory
terraform init -upgrade        # Upgrade providers

# Planning
terraform plan                 # Show changes
terraform plan -out=tfplan     # Save plan

# Applying
terraform apply                # Apply changes
terraform apply -auto-approve  # Skip confirmation
terraform apply tfplan         # Apply saved plan

# Destroying
terraform destroy              # Destroy all resources
terraform destroy -target=RESOURCE  # Destroy specific resource

# State Management
terraform state list           # List resources
terraform state show RESOURCE  # Show resource details
terraform refresh              # Sync state with reality

# Outputs
terraform output               # Show all outputs
terraform output NAME          # Show specific output
terraform output -json         # JSON format

# Validation
terraform validate             # Validate syntax
terraform fmt                  # Format files
terraform fmt -check           # Check formatting

# Other
terraform show                 # Show current state
terraform graph                # Dependency graph
terraform version              # Show version
```

---

## Additional Resources

### Official Documentation
- **Terraform Docs**: https://developer.hashicorp.com/terraform/docs
- **OCI Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/

### Learning Resources
- **HashiCorp Learn**: https://learn.hashicorp.com/terraform
- **OCI Terraform Examples**: https://github.com/oracle/terraform-provider-oci/tree/master/examples
- **Terraform Best Practices**: https://www.terraform-best-practices.com/

### Community
- **Terraform Discuss**: https://discuss.hashicorp.com/c/terraform-core
- **OCI Forums**: https://cloudcustomerconnect.oracle.com/
- **Stack Overflow**: Tag: `terraform`, `oracle-cloud-infrastructure`

---

**End of Day-1 Theory Notes**

🎉 **Congratulations!** You've completed Day 1 of Terraform Zero to Hero!

You now understand:
- What IaC is and why it matters
- Why Terraform is the industry standard
- How to install and configure Terraform for OCI
- How to write, plan, and apply Terraform configurations
- Best practices for security and collaboration

**Ready for Day 2?** Let's dive deeper into advanced Terraform features! 🚀

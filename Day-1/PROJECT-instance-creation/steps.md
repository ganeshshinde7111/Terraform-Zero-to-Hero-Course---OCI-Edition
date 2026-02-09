# Overview of Steps - Creating OCI Resources with Terraform

This guide walks you through creating your first OCI (Oracle Cloud Infrastructure) resource using Terraform - a Compute instance.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Terraform installed
- ✅ OCI CLI installed and configured
- ✅ OCI credentials set up (API keys, OCIDs, region)
- ✅ A compartment OCID where resources will be created
- ✅ Basic understanding of OCI concepts

If you haven't completed these, see:
- [Installation Guide](03-install.md)
- [OCI Connection Setup](04-oci-connection.md)

---

## Step 1: Create a Directory for Your Terraform Project

Create a new directory for your Terraform configuration files:

```bash
# Create project directory
mkdir terraform-oci-first-instance
cd terraform-oci-first-instance
```

---

## Step 2: Create Terraform Configuration Files

In this directory, create the following files:

### 2.1 Create `provider.tf`

This file configures the Terraform OCI provider:

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  region = "us-ashburn-1"  # Change to your home region
  # Provider will use credentials from ~/.oci/config by default
}
```

### 2.2 Create `variables.tf`

Define variables for reusable values:

```hcl
variable "tenancy_ocid" {
  description = "OCID of your tenancy"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the compartment where resources will be created"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "us-ashburn-1"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
```

### 2.3 Create `terraform.tfvars`

Provide values for the variables:

```hcl
# Replace with your actual OCIDs
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaba3pv6wkcr4jqae5f15p2b2m2yt2j6rx32uzr4h25vqstifsfdsq"
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaaxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
region           = "us-ashburn-1"

# Path to your SSH public key
ssh_public_key_path = "~/.ssh/id_rsa.pub"
```

**⚠️ Important**: Add `terraform.tfvars` to `.gitignore` to avoid committing sensitive data!

### 2.4 Create `main.tf`

This is the main configuration file where we define our OCI resources:

```hcl
# Data source to get the list of availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Data source to get the latest Oracle Linux image
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Create a Compute Instance
resource "oci_core_instance" "example" {
  # Required: Availability Domain
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  
  # Required: Compartment
  compartment_id = var.compartment_ocid
  
  # Required: Shape (instance type)
  shape = "VM.Standard.E2.1.Micro"  # Free tier eligible
  
  # Optional: Display name
  display_name = "my-first-terraform-instance"
  
  # Required: Source details (which image to use)
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }
  
  # Required: Network details
  # Note: You'll need to create a VCN and subnet first
  # Or use an existing one
  create_vnic_details {
    subnet_id        = oci_core_subnet.example_subnet.id
    assign_public_ip = true
  }
  
  # Optional: SSH key for access
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
  
  # Optional: Tags
  freeform_tags = {
    "Environment" = "Development"
    "ManagedBy"   = "Terraform"
  }
}
```

### 2.5 Create Network Resources (VCN and Subnet)

Add this to your `main.tf` (or create a separate `network.tf`):

```hcl
# Create a VCN (Virtual Cloud Network)
resource "oci_core_vcn" "example_vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "example-vcn"
  dns_label      = "examplevcn"
}

# Create an Internet Gateway
resource "oci_core_internet_gateway" "example_ig" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "example-internet-gateway"
  enabled        = true
}

# Create a Route Table
resource "oci_core_route_table" "example_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "example-route-table"
  
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.example_ig.id
  }
}

# Create a Security List
resource "oci_core_security_list" "example_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "example-security-list"
  
  # Allow SSH from anywhere (for demo - restrict in production!)
  ingress_security_rules {
    protocol = "6"  # TCP
    source   = "0.0.0.0/0"
    
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  # Allow all outbound traffic
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# Create a Subnet
resource "oci_core_subnet" "example_subnet" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.example_vcn.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "example-subnet"
  dns_label         = "examplesubnet"
  route_table_id    = oci_core_route_table.example_route_table.id
  security_list_ids = [oci_core_security_list.example_security_list.id]
}
```

### 2.6 Create `outputs.tf`

Define outputs to display important information:

```hcl
output "instance_id" {
  description = "OCID of the created instance"
  value       = oci_core_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = oci_core_instance.example.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = oci_core_instance.example.private_ip
}

output "instance_state" {
  description = "Current state of the instance"
  value       = oci_core_instance.example.state
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh opc@${oci_core_instance.example.public_ip}"
}
```

---

## Step 3: Initialize Terraform

Navigate to your project directory and initialize Terraform. This downloads the OCI provider plugin.

```bash
terraform init
```

**Expected Output**:
```
Initializing the backend...

Initializing provider plugins...
- Finding latest version of oracle/oci...
- Installing oracle/oci v5.x.x...
- Installed oracle/oci v5.x.x (signed by a HashiCorp partner)

Terraform has been successfully initialized!
```

**What happens**:
- Downloads the OCI provider plugin
- Creates a `.terraform` directory
- Creates a `.terraform.lock.hcl` file (dependency lock)

---

## Step 4: Validate Configuration (Optional but Recommended)

Check if your configuration is syntactically valid:

```bash
terraform validate
```

**Expected Output**:
```
Success! The configuration is valid.
```

---

## Step 5: Format Your Code (Optional but Recommended)

Format your Terraform files to follow standard conventions:

```bash
terraform fmt
```

This will reformat all `.tf` files in the directory.

---

## Step 6: Create an Execution Plan

Run `terraform plan` to see what Terraform will create:

```bash
terraform plan
```

**What this does**:
- Reads your configuration
- Queries OCI to get current state
- Compares desired state vs. current state
- Shows what will be created, modified, or destroyed

**Expected Output**:
```
Terraform will perform the following actions:

  # oci_core_instance.example will be created
  + resource "oci_core_instance" "example" {
      + id                  = (known after apply)
      + display_name        = "my-first-terraform-instance"
      + shape               = "VM.Standard.E2.1.Micro"
      + public_ip           = (known after apply)
      + private_ip          = (known after apply)
      ...
    }

  # oci_core_vcn.example_vcn will be created
  + resource "oci_core_vcn" "example_vcn" {
      + id           = (known after apply)
      + cidr_block   = "10.0.0.0/16"
      + display_name = "example-vcn"
      ...
    }

  # ... (other resources)

Plan: 5 to add, 0 to change, 0 to destroy.
```

**Review carefully**:
- Ensure it's creating what you expect
- Check for any warnings or errors
- Verify resource counts

---

## Step 7: Apply the Configuration

Apply the configuration to create the OCI resources:

```bash
terraform apply
```

**What happens**:
1. Terraform shows the plan again
2. Prompts you to confirm: `Enter a value: yes`
3. Creates resources in the order required (respecting dependencies)
4. Shows progress
5. Displays outputs

**Expected Output**:
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

oci_core_vcn.example_vcn: Creating...
oci_core_vcn.example_vcn: Creation complete after 5s [id=ocid1.vcn...]
oci_core_internet_gateway.example_ig: Creating...
oci_core_internet_gateway.example_ig: Creation complete after 3s
...
oci_core_instance.example: Creating...
oci_core_instance.example: Still creating... [10s elapsed]
oci_core_instance.example: Still creating... [20s elapsed]
oci_core_instance.example: Creation complete after 45s

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "ocid1.instance.oc1.iad.anuwcl..."
instance_public_ip = "129.213.45.67"
instance_private_ip = "10.0.1.2"
instance_state = "RUNNING"
ssh_connection_command = "ssh opc@129.213.45.67"
```

**Auto-approve option** (skip confirmation):
```bash
terraform apply -auto-approve
```
**⚠️ Use with caution!** Only in development environments.

---

## Step 8: Verify Resources in OCI Console

1. Log in to OCI Console
2. Navigate to **Compute** → **Instances**
3. You should see your newly created instance: "my-first-terraform-instance"
4. Check the status (should be "RUNNING")
5. Note the public IP address

---

## Step 9: Connect to Your Instance (Optional)

If you included SSH key metadata, connect to your instance:

```bash
ssh opc@<instance_public_ip>
```

**Example**:
```bash
ssh opc@129.213.45.67
```

**Note**: 
- Default user for Oracle Linux is `opc`
- Default user for Ubuntu is `ubuntu`
- May take a few minutes after creation for SSH to be available

---

## Step 10: View Terraform State

Terraform tracks all created resources in a state file:

```bash
# Show current state
terraform show

# List all resources in state
terraform state list

# Show specific resource
terraform state show oci_core_instance.example
```

---

## Step 11: View Outputs

Display output values:

```bash
# Show all outputs
terraform output

# Show specific output
terraform output instance_public_ip

# Output in JSON format
terraform output -json
```

---

## Step 12: Make Changes (Optional)

Try modifying your infrastructure:

**Example**: Change the display name

Edit `main.tf`:
```hcl
resource "oci_core_instance" "example" {
  # ... other configuration ...
  display_name = "my-updated-instance"  # Changed
}
```

Then:
```bash
terraform plan   # See what will change
terraform apply  # Apply the change
```

Terraform will update the instance's display name without recreating it.

---

## Step 13: Destroy Resources

When you're done and want to clean up:

```bash
terraform destroy
```

**What happens**:
1. Shows what will be destroyed
2. Asks for confirmation: `Enter a value: yes`
3. Deletes resources in reverse order (respecting dependencies)

**Expected Output**:
```
Plan: 0 to add, 0 to change, 5 to destroy.

Do you really want to destroy all resources?
  Enter a value: yes

oci_core_instance.example: Destroying...
oci_core_instance.example: Still destroying... [10s elapsed]
oci_core_instance.example: Destruction complete after 45s
oci_core_subnet.example_subnet: Destroying...
...

Destroy complete! Resources: 5 destroyed.
```

**⚠️ Important**: 
- Always run `terraform destroy` after demos to avoid charges
- Be very careful with `terraform destroy` in production!
- Free tier resources are free, but it's good practice to clean up

---

## Complete Workflow Summary

```bash
# 1. Initialize
terraform init

# 2. Format code
terraform fmt

# 3. Validate
terraform validate

# 4. Plan
terraform plan

# 5. Apply
terraform apply

# 6. View outputs
terraform output

# 7. Make changes (if needed)
# Edit .tf files
terraform plan
terraform apply

# 8. Destroy (when done)
terraform destroy
```

---

## Common Issues and Solutions

### Issue: "Service error: NotAuthorizedOrNotFound"

**Cause**: Incorrect compartment OCID or insufficient permissions

**Solution**:
```bash
# Verify compartment OCID
oci iam compartment get --compartment-id <your-compartment-ocid>

# List compartments
oci iam compartment list
```

### Issue: "No subnet specified"

**Cause**: Missing VCN/subnet configuration

**Solution**: Ensure you've created the VCN and subnet resources (see Step 2.5)

### Issue: "Image not found"

**Cause**: Image OCID doesn't exist in your region

**Solution**: Use data source to get latest image (as shown in main.tf)

### Issue: "Limit exceeded"

**Cause**: Reached service limits (e.g., max instances in Free Tier)

**Solution**:
- Check existing resources in OCI Console
- Delete unused resources
- Or request limit increase

---

## Best Practices

1. **Always run `terraform plan` before `apply`**
   - Catch errors early
   - Understand what will change

2. **Use variables for reusable values**
   - Don't hardcode OCIDs
   - Makes code more maintainable

3. **Keep state files secure**
   - Never commit to Git
   - Use remote state for teams

4. **Tag your resources**
   - Helps with organization
   - Useful for cost tracking

5. **Use `.gitignore`**
   ```gitignore
   # Terraform
   .terraform/
   *.tfstate
   *.tfstate.*
   .terraform.lock.hcl
   
   # Sensitive files
   *.tfvars
   *.pem
   .oci/
   ```

6. **Destroy test resources**
   - Avoid unexpected charges
   - Keep your environment clean

---

## Next Steps

Congratulations! You've created your first OCI resource with Terraform! 🎉

**What to learn next**:
- Day 2: Variables, Outputs, and Conditional Expressions
- Day 3: Modules and Code Reusability
- Day 4: Remote State and Collaboration
- Day 5: Provisioners
- Day 6: Workspaces
- Day 7: Security and Vault Integration

**Continue practicing**:
- Try creating different instance shapes
- Add multiple instances
- Create a Load Balancer
- Set up Auto Scaling
- Deploy an Autonomous Database

---

## Additional Resources

- **Terraform OCI Provider Documentation**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **OCI Terraform Examples**: https://github.com/oracle/terraform-provider-oci/tree/master/examples
- **Terraform Best Practices**: https://www.terraform-best-practices.com/
- **OCI Free Tier**: https://www.oracle.com/cloud/free/

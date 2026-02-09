# Configure the OCI Provider
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  region = "us-ashburn-1"  # Set your desired OCI region (us-ashburn-1, us-phoenix-1, etc.)
  # The provider will use credentials from ~/.oci/config by default
  # Alternatively, you can specify credentials explicitly:
  # tenancy_ocid     = var.tenancy_ocid
  # user_ocid        = var.user_ocid
  # fingerprint      = var.fingerprint
  # private_key_path = var.private_key_path
}

# Data source to get the list of availability domains
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
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

resource "oci_core_instance" "example" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"  # Free tier eligible shape
  display_name        = "example-instance"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")  # Path to your SSH public key
  }

  # Optional: Add freeform tags
  freeform_tags = {
    "Environment" = "Development"
    "ManagedBy"   = "Terraform"
  }
}

# Variables that need to be defined (create a variables.tf file)
variable "tenancy_ocid" {
  description = "The OCID of your tenancy"
  type        = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment where resources will be created"
  type        = string
}

variable "subnet_ocid" {
  description = "The OCID of the subnet where the instance will be created"
  type        = string
}

# Output the instance details
output "instance_id" {
  description = "OCID of the created instance"
  value       = oci_core_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = oci_core_instance.example.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the instance"
  value       = oci_core_instance.example.private_ip
}

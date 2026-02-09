# Terraform Zero to Hero Course - OCI Edition

## Day 1: Getting Started with Terraform

#### Introduction to Terraform and IaC

In this session, we'll introduce you to the fundamental concepts of Terraform and Infrastructure as Code (IaC). Learn why Terraform is crucial for managing infrastructure and how IaC streamlines provisioning.

#### Installing Terraform on MacOS, Linux and Windows

Get your hands dirty by installing Terraform on both MacOS, Linux and Windows. We'll guide you through the process with clear instructions and commands.

#### Setting up Terraform for OCI

Dive into OCI integration with Terraform. You'll learn how to set up your OCI credentials (API keys, tenancy OCID, user OCID, and fingerprint) and configure the OCI provider within Terraform to start provisioning resources.

#### Writing Your First Terraform Code

Start writing actual Terraform code with a simple example. Learn about the basic structure of a Terraform configuration file and how to define resources using the HCL language.

### Terraform Lifecycle

Understand the lifecycle of terraform. What is terraform `init`, `plan` and `apply`.

#### Launching a Compute Instance

Take your skills up a notch by provisioning a Compute instance on OCI using Terraform. Explore attributes like shape (instance type), image OCID, availability domain, and tags to customize your instance.

#### Terraform State Basics

Understand the importance of Terraform state files. Learn about desired and current states, and how Terraform manages these states to ensure infrastructure consistency.

## Day 2: Advanced Terraform Configuration

#### Understanding Providers and Resources

Deepen your knowledge of providers and resources. Explore the role of different providers for various cloud platforms and understand how resources define infrastructure components.

#### Variables and Outputs in Terraform

Discover the power of variables for dynamic configurations. Learn how to define, declare, and utilize variables effectively. Explore outputs to retrieve and display essential information like instance OCIDs and IP addresses.

#### Conditional Expressions and Functions

Elevate your configurations with conditional expressions, adding logic to your code. We'll introduce you to Terraform's built-in functions for tasks like string manipulation and calculations.

#### Debugging and Formatting Terraform Files

Master the art of debugging Terraform configurations. Plus, learn why proper formatting with terraform fmt is crucial.

## Day 3: Building Reusable Infrastructure with Modules

#### Creating Modular Infrastructure with Terraform Modules

Unlock the potential of reusability with Terraform modules. Understand how modules enable you to create shareable and organized infrastructure components for OCI resources.

#### Local Values and Data Sources

Simplify complex expressions using local values. Dive into data sources and learn how to fetch data from existing OCI resources (like availability domains, images, or existing VCNs) or external systems, enhancing your configurations' flexibility.

#### Using Variables and Inputs with Modules

Explore the versatility of using variables within modules to customize their behavior. Learn how inputs work within modules and the benefits they offer.

#### Leveraging Outputs from Modules

Utilize module outputs to access critical information or propagate data to your root configuration. Learn how to make your modules more informative and useful.

#### Exploring Terraform Registry for Modules

Embark on a journey through the Terraform Registry. Discover pre-built, community-contributed modules for OCI and learn how to incorporate them into your own configurations.

## Day 4: Collaboration and State Management

#### Collaborating with Git and Version Control

Collaborate effectively using Git and version control. Grasp fundamental Git commands such as cloning, pulling, and pushing repositories to enhance teamwork.

#### Handling Sensitive Data and .gitignore

Tackle security challenges associated with sensitive data in version control. Explore the importance of .gitignore to exclude sensitive files (like private API keys, terraform.tfvars with OCIDs) from being committed.

#### Introduction to Terraform Backends

Uncover the role of Terraform backends in remote state storage. Learn why they're essential for maintaining infrastructure state and configurations.

#### Implementing Object Storage Backend for State Storage

Get hands-on experience configuring an OCI Object Storage bucket as a backend for remote state storage. Understand how this setup improves collaboration and state management.

#### State Locking with Object Storage

Dive into state locking and the prevention of concurrent updates. Implement state locking using OCI Object Storage with appropriate configurations, ensuring state consistency during team collaboration.

## Day 5: Provisioning and Provisioners

#### Understanding Provisioners in Terraform

Learn about provisioners, mechanisms for executing actions on resources during creation and destruction. Understand how they facilitate customization.

#### Remote-exec and Local-exec Provisioners

Differentiate between remote-exec and local-exec provisioners. Explore how remote-exec provisions actions on remote Compute instances, while local-exec performs tasks locally.

#### Applying Provisioners at Creation and Destruction 

Discover when to use provisioners during resource creation or destruction. Configure provisioners within resource blocks to execute specific actions on OCI Compute instances.

#### Failure Handling for Provisioners

Gain insights into handling provisioner failures. Learn about retry mechanisms, timeouts, and the on_failure attribute to control provisioner behavior on failure.

## Day 6: Managing Environments with Workspaces

#### Introduction to Terraform Workspaces

Understand the concept of workspaces and their role in managing different environments (dev, staging, production). Learn how workspaces aid in isolating configurations.

#### Creating and Switching Between Workspaces

Learn how to create new workspaces and switch between them using terraform workspace commands. Understand their significance in environment management.

#### Using Workspaces for Environment Management

Learn deeper into how workspaces streamline environment management. Comprehend their benefits in maintaining separate state files for various settings across different OCI compartments or regions.

## Day 7: Security and Advanced Topics

#### HashiCorp Vault Overview

Gain an overview of HashiCorp Vault, a powerful tool for secret management and data protection. Understand its significance in maintaining secure configurations.

#### Integrating Terraform with Vault for Secrets

Learn how to integrate Terraform with Vault to manage sensitive OCI credentials and data securely. Discover how Vault can be used to store and distribute secrets (API keys, private keys, OCIDs) within configurations.

#### OCI-Specific Security Best Practices

Explore OCI-specific security considerations including:
- Proper IAM policy configuration
- Compartment isolation strategies
- Network Security Groups (NSGs) and Security Lists
- Vault service integration for managing secrets
- Using Instance Principals for secure authentication

## Additional OCI-Specific Topics

#### Working with OCI Compartments

Learn how to organize and manage OCI resources using compartments. Understand how to reference compartments in Terraform and implement multi-compartment architectures.

#### Networking in OCI: VCN, Subnets, and Gateways

Deep dive into OCI networking concepts:
- Creating Virtual Cloud Networks (VCNs)
- Configuring subnets (public and private)
- Setting up Internet Gateways, NAT Gateways, and Service Gateways
- Implementing Security Lists and Network Security Groups

#### OCI Data Sources and Resource Dependencies

Master the use of OCI data sources to fetch:
- Availability domains
- Fault domains
- OS images
- Shapes
- Existing network resources

Learn how to create proper resource dependencies in OCI Terraform configurations.

#### Load Balancing and Auto Scaling

Explore how to provision and configure:
- OCI Load Balancers
- Backend Sets and Listeners
- Instance Pools and Auto Scaling configurations
- Health checks and traffic management

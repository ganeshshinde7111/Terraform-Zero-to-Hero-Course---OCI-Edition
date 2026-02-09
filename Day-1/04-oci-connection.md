# Setup Terraform for OCI

To configure OCI credentials and set up Terraform to work with Oracle Cloud Infrastructure, you'll need to follow these steps.

## Prerequisites

Before you begin, ensure you have:
- ✅ An OCI account (Free Tier or Paid)
- ✅ Terraform installed ([see installation guide](03-install.md))
- ✅ Basic understanding of OCI concepts (Tenancy, Compartments, Regions)

---

## Step 1: Install OCI CLI (Command Line Interface)

The OCI CLI is recommended for managing credentials and testing connectivity.

### Windows

**Using PowerShell**:
```powershell
# Download the installer
Invoke-WebRequest -Uri https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.ps1 -OutFile install.ps1

# Run the installer
powershell -ExecutionPolicy Bypass -File install.ps1

# Verify installation
oci --version
```

**Alternative - Using Python pip**:
```powershell
pip install oci-cli
```

### Linux

```bash
# Download and run the installer
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

# Accept defaults or customize installation path
# Default location: ~/bin/oci

# Add to PATH (if not already)
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
oci --version
```

### macOS

**Using Homebrew** (Recommended):
```bash
brew update
brew install oci-cli
```

**Using the installer**:
```bash
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
```

### Verification

```bash
oci --version
# Should output: Oracle Cloud Infrastructure CLI version x.x.x
```

---

## Step 2: Create an OCI Account (If You Don't Have One)

### Sign Up for OCI Free Tier

1. Go to: https://www.oracle.com/cloud/free/
2. Click **"Start for free"**
3. Fill in your details:
   - Email address
   - Country/Territory
   - Name and phone number
4. **Verify email** and complete registration
5. **Provide credit card** (required for verification, but won't be charged for Free Tier)
6. Complete account setup

### OCI Free Tier Includes

**Always Free Resources** (no time limit):
- 2 Compute instances (AMD-based, 1/8 OCPU, 1 GB RAM each)
- 2 Block Volumes (200 GB total)
- 10 GB Object Storage
- 10 GB Archive Storage
- 1 Load Balancer
- 10 TB/month Outbound Data Transfer
- Autonomous Database (2 databases, 20 GB each)

**Free Trial** (30 days, $300 credit):
- Can be used for any OCI service
- Expires after 30 days or when credit is consumed

---

## Step 3: Gather OCI Credentials

To use Terraform with OCI, you need several pieces of information. Let's collect them.

### 3.1 Get Your Tenancy OCID

1. Log in to OCI Console: https://cloud.oracle.com/
2. Click your **Profile icon** (top right)
3. Click on **Tenancy: [Your Tenancy Name]**
4. Copy the **OCID** (starts with `ocid1.tenancy.oc1..`)
5. Save it for later

**Example**:
```
ocid1.tenancy.oc1..aaaaaaaaba3pv6wkcr4jqae5f15p2b2m2yt2j6rx32uzr4h25vqstifsfdsq
```

### 3.2 Get Your User OCID

1. In OCI Console, click your **Profile icon**
2. Click your **username**
3. Copy the **OCID** (starts with `ocid1.user.oc1..`)
4. Save it for later

**Example**:
```
ocid1.user.oc1..aaaaaaaa4seqx6jeyma46ldy4cbuv35q52ox7ewwqwqwjkqwjekjqwekqwe
```

### 3.3 Get Your Compartment OCID

**Option 1: Use Root Compartment** (Simplest for beginners)
- The root compartment OCID is the same as your Tenancy OCID

**Option 2: Create a New Compartment** (Recommended for organization)
1. Navigate to: **Identity & Security** → **Compartments**
2. Click **"Create Compartment"**
3. Provide:
   - Name: e.g., "terraform-demo"
   - Description: "Compartment for Terraform resources"
   - Parent Compartment: (root)
4. Click **"Create Compartment"**
5. Copy the **OCID**

### 3.4 Identify Your Region

Find your home region:
1. In OCI Console, look at the top navigation bar
2. You'll see your current region (e.g., "US East (Ashburn)")
3. Note the **Region Identifier**

**Common Region Identifiers**:
| Region Name | Region Identifier |
|-------------|-------------------|
| US East (Ashburn) | `us-ashburn-1` |
| US West (Phoenix) | `us-phoenix-1` |
| US West (San Jose) | `us-sanjose-1` |
| UK South (London) | `uk-london-1` |
| Germany Central (Frankfurt) | `eu-frankfurt-1` |
| Japan East (Tokyo) | `ap-tokyo-1` |
| Australia East (Sydney) | `ap-sydney-1` |
| India West (Mumbai) | `ap-mumbai-1` |
| South Korea Central (Seoul) | `ap-seoul-1` |
| Canada Southeast (Montreal) | `ca-montreal-1` |
| Brazil East (Sao Paulo) | `sa-saopaulo-1` |

Full list: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm

---

## Step 4: Create API Keys

Terraform uses API keys to authenticate with OCI. You need to generate an RSA key pair.

### 4.1 Generate API Key Pair

**Linux/macOS/Git Bash (Windows)**:

```bash
# Create OCI directory
mkdir -p ~/.oci

# Generate private key
openssl genrsa -out ~/.oci/oci_api_key.pem 2048

# Set proper permissions (important!)
chmod 600 ~/.oci/oci_api_key.pem

# Generate public key from private key
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

**Windows (PowerShell without OpenSSL)**:
- Download Git Bash and use the commands above
- Or use the OCI Console to generate keys (see Option 2 below)

### 4.2 Upload Public Key to OCI

**Option 1: Using OCI Console** (Recommended for beginners)

1. Log in to OCI Console
2. Click your **Profile icon** → Click your **username**
3. In the left sidebar, click **"API Keys"**
4. Click **"Add API Key"**
5. Select **"Paste Public Key"**
6. Open the public key file:
   ```bash
   cat ~/.oci/oci_api_key_public.pem
   ```
7. Copy the entire content (including `-----BEGIN PUBLIC KEY-----` and `-----END PUBLIC KEY-----`)
8. Paste into the OCI Console
9. Click **"Add"**

**Option 2: Let OCI Generate Keys** (Easier but less control)

1. In the "Add API Key" dialog
2. Select **"Generate API Key Pair"**
3. Click **"Download Private Key"** (save it as `~/.oci/oci_api_key.pem`)
4. Click **"Download Public Key"** (optional, for backup)
5. Click **"Add"**

### 4.3 Get the Fingerprint

After adding the API key, OCI displays a **Fingerprint** (looks like `aa:bb:cc:dd:...`).

**Copy and save this fingerprint** - you'll need it for configuration.

You can always find it later:
1. Profile → Username → API Keys
2. The fingerprint is listed next to your key

---

## Step 5: Configure OCI CLI

Now configure the OCI CLI with your credentials.

### Run OCI Setup Config

```bash
oci setup config
```

**You'll be prompted for**:

1. **Enter a location for your config** 
   - Press Enter to accept default: `~/.oci/config`

2. **Enter a user OCID**
   - Paste your User OCID (from Step 3.2)

3. **Enter a tenancy OCID**
   - Paste your Tenancy OCID (from Step 3.1)

4. **Enter a region**
   - Enter region identifier (e.g., `us-ashburn-1`)

5. **Do you want to generate a new API Signing RSA key pair?**
   - If you already generated keys: Enter `n`
   - If you want OCI CLI to generate: Enter `Y`

6. **If you said 'n', enter the location of your API Signing private key file**
   - Enter: `~/.oci/oci_api_key.pem`

### Verify Configuration

```bash
# View your config file
cat ~/.oci/config
```

**Should look like**:
```ini
[DEFAULT]
user=ocid1.user.oc1..aaaaaaaa...
fingerprint=aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99
tenancy=ocid1.tenancy.oc1..aaaaaaaaba3pv6wkcr4jqae5f15p2b2m2yt2j6rx32uzr4h25vqstifsfdsq
region=us-ashburn-1
key_file=/home/username/.oci/oci_api_key.pem
```

---

## Step 6: Test OCI CLI Connection

Verify that OCI CLI can connect to your tenancy.

### Test Commands

```bash
# Get Object Storage namespace
oci os ns get

# Expected output:
# {
#   "data": "your-namespace"
# }

# List compute instances (may be empty)
oci compute instance list --compartment-id <your-compartment-ocid>

# List availability domains
oci iam availability-domain list

# Get current user info
oci iam user get --user-id <your-user-ocid>
```

**If any command fails**:
- Check OCIDs are correct
- Verify API key fingerprint matches
- Ensure private key file exists and has correct permissions
- Confirm you're using the right region

---

## Step 7: Configure Terraform for OCI

Now that OCI CLI is configured, Terraform can use the same credentials.

### Create a Terraform Configuration Directory

```bash
# Create project directory
mkdir -p ~/terraform-oci-demo
cd ~/terraform-oci-demo
```

### Create provider.tf

Create a file named `provider.tf`:

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
  # The provider will automatically use credentials from ~/.oci/config
  # using the [DEFAULT] profile
  
  region = "us-ashburn-1"  # Change to your region
  
  # Alternatively, you can specify credentials explicitly:
  # tenancy_ocid     = var.tenancy_ocid
  # user_ocid        = var.user_ocid
  # fingerprint      = var.fingerprint
  # private_key_path = var.private_key_path
}
```

### Create variables.tf (Optional but Recommended)

```hcl
variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaa..."  # Your tenancy OCID
}

variable "compartment_ocid" {
  description = "The OCID of the compartment"
  type        = string
  default     = "ocid1.compartment.oc1..aaaaaaa..."  # Your compartment OCID
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "us-ashburn-1"
}
```

### Initialize Terraform

```bash
terraform init
```

**Expected output**:
```
Initializing the backend...

Initializing provider plugins...
- Finding latest version of oracle/oci...
- Installing oracle/oci v5.x.x...
- Installed oracle/oci v5.x.x

Terraform has been successfully initialized!
```

---

## Step 8: Create Your First OCI Resource

Let's create a simple resource to verify everything works.

### Create main.tf

```hcl
# Get availability domain
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

# Output the availability domain name
output "availability_domain" {
  value = data.oci_identity_availability_domain.ad.name
}

# Get Object Storage namespace
data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.tenancy_ocid
}

output "namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}
```

### Run Terraform

```bash
# Plan
terraform plan

# Apply
terraform apply
```

**Type `yes` when prompted.**

**Expected output**:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

availability_domain = "xxxx:US-ASHBURN-AD-1"
namespace = "your-namespace"
```

---

## Configuration Methods Comparison

### Method 1: Use OCI CLI Config (Recommended for Beginners)

**Pros**:
- ✅ Simple setup
- ✅ Shared between OCI CLI and Terraform
- ✅ No credentials in Terraform files

**Configuration**:
```hcl
provider "oci" {
  region = "us-ashburn-1"
  # Uses ~/.oci/config [DEFAULT] profile
}
```

### Method 2: Environment Variables

**Pros**:
- ✅ No credentials in files
- ✅ Good for CI/CD

**Setup**:
```bash
export TF_VAR_tenancy_ocid="ocid1.tenancy..."
export TF_VAR_user_ocid="ocid1.user..."
export TF_VAR_fingerprint="aa:bb:cc..."
export TF_VAR_private_key_path="~/.oci/oci_api_key.pem"
export TF_VAR_region="us-ashburn-1"
```

**Configuration**:
```hcl
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
```

### Method 3: Explicit Variables (Not Recommended for Production)

**Configuration**:
```hcl
provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaa..."
  user_ocid        = "ocid1.user.oc1..aaaa..."
  fingerprint      = "aa:bb:cc:..."
  private_key_path = "~/.oci/oci_api_key.pem"
  region           = "us-ashburn-1"
}
```

**⚠️ Warning**: Never commit credentials to Git!

---

## Security Best Practices

### ✅ DO:

1. **Use proper file permissions**:
   ```bash
   chmod 600 ~/.oci/oci_api_key.pem
   chmod 600 ~/.oci/config
   ```

2. **Add to .gitignore**:
   ```gitignore
   # Terraform
   *.tfstate
   *.tfstate.*
   .terraform/
   
   # Credentials
   *.pem
   *.tfvars
   .oci/
   ```

3. **Use separate compartments** for different environments

4. **Rotate API keys** periodically

5. **Use OCI Vault** for sensitive data in production

### ❌ DON'T:

1. ❌ Commit private keys to Git
2. ❌ Share API keys via email or chat
3. ❌ Use root compartment for everything
4. ❌ Give excessive permissions
5. ❌ Hardcode credentials in .tf files

---

## Troubleshooting

### Issue: "Service error: NotAuthenticated"

**Possible causes**:
- Wrong OCIDs
- Wrong fingerprint
- Private key doesn't match public key
- File permissions too open

**Solution**:
```bash
# Verify config
cat ~/.oci/config

# Check fingerprint in OCI Console
# Profile → Username → API Keys

# Verify key permissions
ls -la ~/.oci/
chmod 600 ~/.oci/oci_api_key.pem
```

### Issue: "terraform init" fails to download OCI provider

**Solution**:
```bash
# Check internet connection
ping terraform.io

# Try with explicit provider version
# In provider.tf, specify version exactly:
version = "= 5.20.0"
```

### Issue: Can't find compartment

**Solution**:
```bash
# List all compartments
oci iam compartment list

# Verify you're using the correct compartment OCID
```

### Issue: Region not found

**Solution**:
- Verify region identifier (e.g., `us-ashburn-1`, not `us-east`)
- Check list: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm

---

## Next Steps

Now that Terraform is configured for OCI:

1. ✅ OCI account created
2. ✅ OCI CLI installed and configured
3. ✅ API keys generated and uploaded
4. ✅ Terraform initialized with OCI provider
5. ⏭️ **Next**: Write your first Terraform script to create OCI resources

Continue to **steps.md** to create your first Compute instance!

---

## Summary Checklist

Before proceeding, ensure:

- [ ] OCI CLI installed (`oci --version`)
- [ ] OCI account created and accessible
- [ ] Tenancy OCID obtained
- [ ] User OCID obtained
- [ ] Compartment OCID obtained
- [ ] Region identified
- [ ] API key pair generated
- [ ] Public key uploaded to OCI
- [ ] Fingerprint saved
- [ ] `~/.oci/config` created and configured
- [ ] OCI CLI tested (`oci os ns get`)
- [ ] Terraform initialized (`terraform init`)
- [ ] Test Terraform configuration ran successfully

**All checked?** You're ready to build OCI infrastructure with Terraform! 🚀

---

## Additional Resources

- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
- **OCI Terraform Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **OCI CLI Reference**: https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/
- **Terraform OCI Examples**: https://github.com/oracle/terraform-provider-oci/tree/master/examples
- **OCI Free Tier**: https://www.oracle.com/cloud/free/

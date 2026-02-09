# Install Terraform

Terraform installation is straightforward across all operating systems. Follow the instructions for your platform below.

## Windows

### Option 1: Download from HashiCorp (Recommended)

1. Visit the Terraform Downloads [Page](https://developer.hashicorp.com/terraform/downloads)
2. Download the Windows version (usually AMD64)
3. Extract the downloaded ZIP file
4. Move the `terraform.exe` to a directory in your PATH (e.g., `C:\Windows\System32` or create a dedicated folder like `C:\terraform`)
5. Add the directory to your system PATH if needed:
   - Right-click "This PC" → Properties → Advanced System Settings
   - Click "Environment Variables"
   - Under "System Variables", find "Path" and click "Edit"
   - Add the directory containing terraform.exe

### Option 2: Using Chocolatey Package Manager

If you have Chocolatey installed:
```powershell
choco install terraform
```

### Option 3: Using Windows Package Manager (winget)

```powershell
winget install HashiCorp.Terraform
```

### Verification (Windows)

Open PowerShell or Git Bash and run:
```bash
terraform --version
```

You should see output like:
```
Terraform v1.6.0
```

**Important for Windows Users**:
- **Use Git Bash or PowerShell** instead of CMD for better compatibility
- Git Bash is recommended as most Linux commands work there
- Install Git Bash from: https://git-scm.com/downloads

---

## Linux

### Ubuntu/Debian

```bash
# Update package index
sudo apt-get update

# Install dependencies
sudo apt-get install -y gnupg software-properties-common

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform
sudo apt-get update
sudo apt-get install terraform
```

### CentOS/RHEL/Fedora

```bash
# Install yum-config-manager
sudo yum install -y yum-utils

# Add HashiCorp repository
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Terraform
sudo yum -y install terraform
```

### Arch Linux

```bash
sudo pacman -S terraform
```

### Manual Installation (Any Linux)

```bash
# Download the latest version
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip

# Unzip
unzip terraform_1.6.0_linux_amd64.zip

# Move to PATH
sudo mv terraform /usr/local/bin/

# Verify
terraform --version
```

### Verification (Linux)

```bash
terraform --version
```

---

## macOS

### Option 1: Using Homebrew (Recommended)

If you have Homebrew installed:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Option 2: Manual Download

1. Visit the Terraform Downloads [Page](https://developer.hashicorp.com/terraform/downloads)
2. Download the macOS version (AMD64 for Intel Macs, ARM64 for M1/M2 Macs)
3. Extract the ZIP file
4. Move terraform to `/usr/local/bin/`:
   ```bash
   sudo mv terraform /usr/local/bin/
   ```

### Verification (macOS)

```bash
terraform --version
```

---

## GitHub Codespaces (Cloud-Based Development)

**Perfect for users who**:
- Don't have a laptop or have limited resources
- Are using office machines with restrictions
- Want a quick setup without local installation
- Need a consistent development environment

### Benefits of GitHub Codespaces

✅ **Free for 60 hours per month** (with GitHub Free account)  
✅ **120 hours per month** (with GitHub Pro account)  
✅ Includes: 2-core CPU, 4GB RAM, 32GB storage  
✅ Pre-configured Ubuntu environment with VS Code  
✅ Access from any device with a web browser  
✅ No local installation required  
✅ Terraform and OCI CLI can be pre-installed  

### How to Use GitHub Codespaces

#### Step 1: Fork the Repository

1. Go to the course GitHub repository
2. Click the **Fork** button (top right)
3. This creates your own copy of the repository

#### Step 2: Create a Codespace

1. In your forked repository, click the **Code** button (green button)
2. Select the **Codespaces** tab
3. Click **Create codespace on main**
4. Wait for the environment to be created (2-5 minutes first time)

#### Step 3: Configure Dev Container for Terraform and OCI CLI

Once your Codespace opens:

1. **Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)**
2. Type and select: **"Add Dev Container Configuration Files"**
3. Click **"Modify your active configuration"**
4. Search for **"Terraform"**
5. Select **"Terraform, tflint, and Terragrunt"** (with verified checkmark)
6. Click **OK**, keep defaults

7. **Repeat the process for OCI CLI**:
   - Press `Ctrl+Shift+P` again
   - Select **"Add Dev Container Configuration Files"**
   - Click **"Modify your active configuration"**
   - Search for **"OCI CLI"** or **"Oracle Cloud"**
   - Select the appropriate option
   - Click **OK**, keep defaults

8. **Rebuild the Container**:
   - Press `Ctrl+Shift+P`
   - Type and select: **"Rebuild Container"**
   - Confirm by clicking **"Rebuild Now"**
   - Wait 5-10 minutes for the rebuild

#### Step 4: Verify Installation

After rebuild completes, open the terminal:
```bash
# Check Terraform
terraform --version

# Check OCI CLI
oci --version
```

### Using the Codespace

**Start/Stop Codespace**:
- Your Codespace persists even after closing the browser
- Go to: https://github.com/codespaces
- Click on your Codespace to reopen it
- Stop when not in use to save hours

**File Structure**:
```
your-repository/
├── .devcontainer/
│   └── devcontainer.json  # Don't delete this!
├── Day-1/
├── Day-2/
└── ...
```

**Tips**:
- The `.devcontainer/devcontainer.json` file configures your environment
- Don't delete this file - it's needed for Terraform and OCI CLI
- Your Codespace has full VS Code functionality
- You can install VS Code extensions
- Changes are saved automatically

### Managing Codespace Hours

**Free Tier**: 60 hours/month (GitHub Free)
- Good for 2 hours/day for 30 days
- Or 3 hours/day for 20 days

**If you exceed hours**:
- Create a new GitHub account (not ideal but works)
- Upgrade to GitHub Pro ($4/month for 120 hours)
- Use local installation instead

**Best Practices**:
- Stop Codespace when not using it
- Delete unused Codespaces
- Use local installation if you have a good laptop

---

## Visual Studio Code (Recommended IDE)

While Terraform can be used with any text editor, **VS Code** is highly recommended.

### Why VS Code?

✅ Free and open-source  
✅ Excellent Terraform support  
✅ Syntax highlighting and auto-completion  
✅ Linting and error detection  
✅ Integrated terminal  
✅ Git integration  
✅ Available on Windows, Linux, macOS  

### Install VS Code

Download from: https://code.visualstudio.com/

### Recommended VS Code Extensions for Terraform

After installing VS Code, install these extensions:

1. **HashiCorp Terraform** (by HashiCorp)
   - Syntax highlighting
   - IntelliSense (auto-completion)
   - Code navigation
   - Formatting

2. **HashiCorp HCL** (by HashiCorp)
   - HCL syntax support
   - Better linting

3. **Terraform doc snippets** (optional)
   - Quick code snippets

4. **GitLens** (optional)
   - Enhanced Git integration

### Installing Extensions

**Method 1**: Through VS Code UI
1. Open VS Code
2. Click Extensions icon (left sidebar) or press `Ctrl+Shift+X`
3. Search for "HashiCorp Terraform"
4. Click **Install**

**Method 2**: Command Line
```bash
code --install-extension hashicorp.terraform
code --install-extension hashicorp.hcl
```

### VS Code Settings for Terraform

Add to your VS Code settings (`Ctrl+,`):
```json
{
  "terraform.languageServer": {
    "enabled": true
  },
  "terraform.experimentalFeatures.validateOnSave": true,
  "[terraform]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "hashicorp.terraform"
  }
}
```

---

## Verification Checklist

After installation, verify everything is working:

### ✅ Terraform
```bash
terraform --version
# Should show: Terraform v1.6.x or higher
```

### ✅ Terraform Commands
```bash
terraform -help
# Should show list of available commands
```

### ✅ Terraform Providers
```bash
# Create a test directory
mkdir terraform-test
cd terraform-test

# Create a test file
cat > main.tf << 'EOF'
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}
EOF

# Initialize (downloads OCI provider)
terraform init

# Should show: "Terraform has been successfully initialized!"
```

---

## Next Steps

Now that Terraform is installed:

1. ✅ Terraform installed and verified
2. ⏭️ **Next**: Install and configure OCI CLI
3. ⏭️ **Then**: Set up OCI authentication for Terraform
4. ⏭️ **Finally**: Write your first Terraform configuration

Continue to **04-oci-connection.md** to set up OCI CLI and authentication.

---

## Troubleshooting

### Issue: "terraform: command not found"

**Solution**:
- Windows: Add terraform.exe directory to PATH
- Linux/Mac: Ensure `/usr/local/bin` is in PATH
- Verify: `echo $PATH` should include the terraform directory

### Issue: Permission denied (Linux/Mac)

**Solution**:
```bash
sudo chmod +x /usr/local/bin/terraform
```

### Issue: Codespace not starting

**Solution**:
- Check GitHub account status
- Verify you haven't exceeded free hours
- Try creating a new Codespace
- Clear browser cache

### Issue: Terraform version outdated

**Solution**:
```bash
# Uninstall old version
sudo rm /usr/local/bin/terraform

# Download and install latest version
# Follow installation steps above
```

---

## Summary

You now have Terraform installed! Choose the method that works best for you:

- **Local Installation**: Best for regular use
- **GitHub Codespaces**: Best for learning, limited resources, or testing
- **Both**: Use local for daily work, Codespaces for experimentation

**Installation Time**:
- Local: 5-10 minutes
- Codespaces: 10-15 minutes (first time)

**Next**: Install and configure OCI CLI → [04-oci-connection.md](04-oci-connection.md)

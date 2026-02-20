# Backstage Golden Path Template

Complete template for provisioning AWS infrastructure using Backstage, GitLab CI, and Terraform Enterprise.

## 🚀 Quick Start (for Mac POC)

Your template is ready to use! Run this single command:

```bash
cd /Users/smarticle/backstage-setup/backstage-golden-path
./setup.sh
```

This will:
- Find your Backstage installation
- Copy all template files
- Show you what to do next

## 📁 What's Included

```
backstage-golden-path/
├── template.yaml                # Backstage template definition
├── content/                     # Files that get copied to new repos
│   ├── .gitlab-ci.yml          # GitLab CI pipeline
│   ├── catalog-info.yaml       # Backstage catalog entry
│   ├── terraform/
│   │   ├── main.tf             # AWS infrastructure
│   │   ├── variables.tf        # Configuration variables
│   │   └── outputs.tf          # Output values
│   └── scripts/
│       ├── install-docker.sh   # Docker installation
│       ├── install-kubectl.sh  # kubectl installation
│       ├── install-helm.sh     # Helm installation
│       └── deploy-app.sh       # App deployment
├── setup.sh                    # Automated setup script
└── SETUP-INSTRUCTIONS.md       # Detailed instructions
```

## 🎯 What It Does

1. **User fills form** in Backstage UI
2. **Creates GitLab repo** with all infrastructure code
3. **GitLab CI runs** automatically:
   - Validates Terraform
   - Creates infrastructure plan
   - Provisions AWS resources (VPC, EC2, optional EKS)
   - Installs Docker, kubectl, Helm on new instances
   - Deploys applications
   - Runs health checks

## 📋 Prerequisites

Before running `setup.sh`, you need:

1. **Backstage running** at `http://localhost:3000` on your Mac
2. **GitLab account** with personal access token
3. **Terraform Cloud** account with API token
4. **AWS credentials** with appropriate permissions

## 🔧 Manual Setup (if script doesn't work)

If the script doesn't work or you prefer manual setup:

1. **Find your Backstage directory**
   ```bash
   # It's where you installed Backstage, e.g.:
   cd /Users/smarticle/backstage
   ```

2. **Copy template files**
   ```bash
   mkdir -p templates/aws-infrastructure-golden-path
   cp -r /Users/smarticle/backstage-setup/backstage-golden-path/* \
         templates/aws-infrastructure-golden-path/
   ```

3. **Update app-config.yaml**
   Add this to your `app-config.yaml`:
   ```yaml
   catalog:
     locations:
       - type: file
         target: ./templates/aws-infrastructure-golden-path/template.yaml
         rules:
           - allow: [Template]
   
   integrations:
     gitlab:
       - host: gitlab.com
         token: ${GITLAB_TOKEN}
   ```

4. **Set environment variables**
   ```bash
   export GITLAB_TOKEN="your-gitlab-token"
   export TFE_TOKEN="your-terraform-token"
   export TFE_ORGANIZATION="your-org-name"
   ```

5. **Restart Backstage**
   ```bash
   yarn dev
   ```

6. **Verify**
   - Open `http://localhost:3000`
   - Click "Create"
   - Look for "AWS Infrastructure Golden Path"

## ✅ Testing

After setup, test the template:

1. Go to Backstage → **Create**
2. Select **AWS Infrastructure Golden Path**
3. Fill out the form:
   - Project name: `test-app`
   - Environment: `dev`
   - AWS Region: `us-east-1`
   - Instance type: `t3.small`
4. Click **Create**
5. Watch the pipeline in GitLab!

## 🐛 Troubleshooting

### Template not showing?
```bash
# Check if template exists
ls -la /path/to/backstage/templates/aws-infrastructure-golden-path/template.yaml

# Check catalog config
cat /path/to/backstage/app-config.yaml | grep -A 5 "catalog:"

# Force refresh
curl -X POST http://localhost:3000/api/catalog/refresh
```

### GitLab integration not working?
- Verify `GITLAB_TOKEN` is set: `echo $GITLAB_TOKEN`
- Token needs these scopes: `api`, `read_repository`, `write_repository`
- Generate at: https://gitlab.com/-/profile/personal_access_tokens

### Environment variables not working?
Make them permanent by adding to `~/.zshrc`:
```bash
echo 'export GITLAB_TOKEN="your-token"' >> ~/.zshrc
source ~/.zshrc
```

## 📚 Documentation

- **[SETUP-INSTRUCTIONS.md](SETUP-INSTRUCTIONS.md)** - Detailed setup guide
- **[backstage-golden-path-installation.md](../backstage-golden-path-installation.md)** - Complete deployment guide

## 🏗️ Architecture

```
Backstage Form
      ↓
Create GitLab Repo
      ↓
GitLab CI Pipeline
      ↓
   ┌──────────────────────┐
   │ Terraform Validate   │
   └──────────────────────┘
            ↓
   ┌──────────────────────┐
   │ Terraform Plan       │
   └──────────────────────┘
            ↓
   ┌──────────────────────┐
   │ Terraform Apply      │ (Manual approval)
   │  - Create VPC        │
   │  - Create EC2        │
   │  - Create EKS        │
   └──────────────────────┘
            ↓
   ┌──────────────────────┐
   │ Deploy to EC2        │
   │  - SSH to instance   │
   │  - Install Docker    │
   │  - Install kubectl   │
   │  - Install Helm      │
   │  - Deploy app        │
   └──────────────────────┘
            ↓
   ┌──────────────────────┐
   │ Health Checks        │
   └──────────────────────┘
            ↓
        ✅ Done!
```

## 🤝 Support

Questions? Check the detailed documentation or review the example workflows in the template.

## 🎉 Ready?

Run the setup script and start creating infrastructure with GitOps best practices!

```bash
./setup.sh
```

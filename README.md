# Backstage Setup & Templates

Complete Backstage Golden Path template for AWS infrastructure provisioning with GitLab CI and Terraform Enterprise.

## 📁 Folder Structure

```
backstage-setup/
├── README.md                                    # This file - overview
│
├── backstage-golden-path/                       # ⭐ READY-TO-USE TEMPLATE
│   ├── README.md                                # Quick start guide
│   ├── SETUP-INSTRUCTIONS.md                    # Detailed setup steps
│   ├── setup.sh                                 # Automated installation script
│   ├── template.yaml                            # Backstage template definition
│   └── content/                                 # Template content files
│       ├── .gitlab-ci.yml                       # GitLab CI pipeline
│       ├── catalog-info.yaml                    # Backstage catalog entry
│       ├── terraform/                           # Terraform infrastructure
│       │   ├── main.tf                          # AWS resources (VPC, EC2, EKS)
│       │   ├── variables.tf                     # Configuration variables
│       │   └── outputs.tf                       # Infrastructure outputs
│       └── scripts/                             # Deployment scripts
│           ├── install-docker.sh                # Docker installation
│           ├── install-kubectl.sh               # kubectl installation
│           ├── install-helm.sh                  # Helm installation
│           └── deploy-app.sh                    # Application deployment
│
├── backstage-golden-path-template.yaml          # Original template (reference)
├── backstage-template-content/                  # Original content (reference)
└── backstage-golden-path-installation.md        # Complete deployment guide
```

## 🚀 Quick Start

### For Mac POC (localhost:3000)

Run the automated setup script:

```bash
cd /Users/smarticle/backstage-setup/backstage-golden-path
./setup.sh
```

This will:
1. Find your Backstage installation
2. Copy template files to the correct location
3. Show you the next steps

### What You Need

Before running the setup:
- ✅ Backstage running at `http://localhost:3000`
- ✅ GitLab account + personal access token
- ✅ Terraform Cloud account + API token
- ✅ AWS credentials

## 📖 Documentation

- **[backstage-golden-path/README.md](backstage-golden-path/README.md)** - Quick start & overview
- **[backstage-golden-path/SETUP-INSTRUCTIONS.md](backstage-golden-path/SETUP-INSTRUCTIONS.md)** - Detailed setup guide
- **[backstage-golden-path-installation.md](backstage-golden-path-installation.md)** - Complete deployment documentation

## 🎯 What This Template Does

```
User fills form in Backstage
        ↓
Creates GitLab repository
        ↓
GitLab CI Pipeline starts
        ↓
Stage 1: Terraform Enterprise provisions infrastructure
  - VPC, Subnets, Security Groups
  - EC2 instances
  - Optional EKS cluster
        ↓
Stage 2: Deploy applications
  - SSH to new EC2 instances
  - Install Docker, kubectl, Helm
  - Deploy applications
        ↓
Stage 3: Verify deployment
  - Run health checks
  - Report status
        ↓
View in Backstage catalog
```

## 🏗️ Architecture Components

### Backstage Template
- Form-driven infrastructure creation
- Integrated with GitLab for repository creation
- Automatic catalog registration
- Pipeline status visibility

### GitLab CI Pipeline
- **Validate**: Terraform format and validation
- **Plan**: Infrastructure planning
- **Provision**: AWS resource creation (manual approval)
- **Deploy**: Application deployment to EC2/EKS
- **Verify**: Health checks and validation

### Terraform Infrastructure
- Virtual Private Cloud (VPC)
- EC2 instances with security groups
- Optional EKS cluster for Kubernetes
- Configurable instance types and regions

### Deployment Scripts
- Automated Docker installation
- Kubernetes tools (kubectl, Helm)
- Application deployment automation
- Health check scripts

## 🛠️ Usage

### Step 1: Install Template

```bash
# Navigate to the template directory
cd /Users/smarticle/backstage-setup/backstage-golden-path

# Run setup script
./setup.sh

# Follow the prompts and instructions
```

### Step 2: Configure Backstage

Add to your `app-config.yaml`:

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

### Step 3: Set Environment Variables

```bash
export GITLAB_TOKEN="your-gitlab-personal-access-token"
export TFE_TOKEN="your-terraform-cloud-token"
export TFE_ORGANIZATION="your-terraform-org"
```

### Step 4: Use in Backstage

1. Open `http://localhost:3000`
2. Click **"Create"** in sidebar
3. Select **"AWS Infrastructure Golden Path"**
4. Fill out the form
5. Watch the magic happen! ✨

## 📊 Template Features

### Infrastructure Options
- **AWS Regions**: us-east-1, us-west-2, eu-west-1, ap-southeast-1
- **Environments**: dev, staging, production
- **Instance Types**: t3.micro, t3.small, t3.medium, t3.large
- **Kubernetes**: Optional EKS cluster
- **Networking**: Configurable VPC CIDR blocks

### Deployment Options
- EC2 instance deployment with Docker
- Kubernetes deployment with kubectl
- Helm chart deployment
- Custom Docker images or build from Dockerfile

### Pipeline Stages
- Automated Terraform validation
- Infrastructure planning with cost estimates
- Manual approval for production changes
- Automated deployment scripts
- Health check verification
- Rollback on failure

## 🔧 Customization

### Add Custom Terraform Modules

Edit `backstage-golden-path/content/terraform/main.tf` to add:
- RDS databases
- ElastiCache clusters
- S3 buckets
- CloudFront distributions
- Lambda functions

### Modify Pipeline Stages

Edit `backstage-golden-path/content/.gitlab-ci.yml` to:
- Add testing stages
- Include security scanning
- Add notification steps
- Customize deployment logic

### Add More Scripts

Create new scripts in `backstage-golden-path/content/scripts/`:
- Monitoring setup (CloudWatch, Datadog)
- Security hardening
- Application configuration
- Database migrations

## 🐛 Troubleshooting

### Template not showing in Backstage?

```bash
# Verify files were copied
ls -la /path/to/backstage/templates/aws-infrastructure-golden-path/

# Check catalog configuration
cat /path/to/backstage/app-config.yaml | grep -A 10 "catalog:"

# Refresh catalog
curl -X POST http://localhost:3000/api/catalog/refresh
```

### GitLab integration issues?

- Verify token: `echo $GITLAB_TOKEN`
- Check token scopes: `api`, `read_repository`, `write_repository`
- Test GitLab API: `curl -H "PRIVATE-TOKEN: $GITLAB_TOKEN" https://gitlab.com/api/v4/user`

### Backstage setup script fails?

Run manually:
```bash
# Find Backstage
ls -la ~ | grep backstage

# Copy files manually
BACKSTAGE_PATH="/path/to/your/backstage"
cp -r backstage-golden-path/* $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/
```

## 📚 Additional Resources

### AWS Documentation
- [Amazon VPC](https://docs.aws.amazon.com/vpc/)
- [Amazon EC2](https://docs.aws.amazon.com/ec2/)
- [Amazon EKS](https://docs.aws.amazon.com/eks/)

### Backstage Documentation
- [Software Templates](https://backstage.io/docs/features/software-templates/)
- [Software Catalog](https://backstage.io/docs/features/software-catalog/)
- [TechDocs](https://backstage.io/docs/features/techdocs/)

### GitLab CI/CD
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [Pipeline Configuration](https://docs.gitlab.com/ee/ci/yaml/)
- [Variables](https://docs.gitlab.com/ee/ci/variables/)

### Terraform
- [Terraform Language](https://developer.hashicorp.com/terraform/language)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs)

## 🤝 Support & Contribution

For questions or issues:
1. Check the detailed documentation in each folder
2. Review the troubleshooting sections
3. Consult the official documentation links above

## 📝 Notes

- The `backstage-template-content/` folder contains the original template files (kept for reference)
- The `backstage-golden-path/` folder is the active, ready-to-use template
- All scripts are tested on macOS and Amazon Linux 2

## 🎉 Ready to Build!

Start by running:
```bash
cd backstage-golden-path
./setup.sh
```

Happy infrastructure provisioning! 🚀

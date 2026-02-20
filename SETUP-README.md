# Backstage + GitLab + Terraform + AWS Integration Setup

Complete setup guide for deploying AWS infrastructure using Backstage templates, GitLab CI, and Terraform.

## 🏗️ Architecture

```
┌─────────────┐
│  Backstage  │  User fills form in UI
│   (Local)   │
└──────┬──────┘
       │ Creates repository
       ↓
┌─────────────┐
│   GitLab    │  Stores Terraform code
│ Repository  │  Triggers CI pipeline
└──────┬──────┘
       │ CI/CD Pipeline
       ↓
┌─────────────┐
│ GitLab CI   │  Reads AWS credentials
│    Runner   │  Executes Terraform
└──────┬──────┘
       │ Provisions infrastructure
       ↓
┌─────────────┐
│     AWS     │  EC2, VPC, EKS, etc.
│   Account   │  Resources created
└─────────────┘
```

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ **Backstage** running locally (http://localhost:3000)
- ✅ **GitLab account** with admin access to a group/namespace
- ✅ **GitLab Personal Access Token** with `api`, `write_repository` scopes
- ✅ **AWS account** with programmatic access
- ✅ **AWS Access Key** and **Secret Key** with EC2/VPC permissions
- ✅ **Terraform Cloud account** (optional, if using Terraform Enterprise)

## 🚀 Setup Steps

### Step 1: Configure AWS Credentials in GitLab

AWS credentials need to be stored in GitLab so the CI pipeline can provision resources.

1. **Get your AWS credentials:**
   ```bash
   # If you have AWS CLI configured
   aws configure get aws_access_key_id
   aws configure get aws_secret_access_key
   aws sts get-caller-identity  # Get your account ID
   ```

2. **Add to GitLab:**
   - Go to your GitLab group: `https://gitlab.com/your-group`
   - Navigate to: **Settings → CI/CD → Variables**
   - Click **Add Variable** and add each of these:

   | Variable Name | Value | Type | Protected | Masked |
   |--------------|-------|------|-----------|--------|
   | `AWS_ACCESS_KEY_ID` | Your AWS access key | Variable | ✓ | ✓ |
   | `AWS_SECRET_ACCESS_KEY` | Your AWS secret key | Variable | ✓ | ✓ |
   | `AWS_DEFAULT_REGION` | `us-east-1` | Variable | ✓ | ✗ |
   | `AWS_ACCOUNT_ID` | Your 12-digit account ID | Variable | ✓ | ✗ |
   | `TFE_TOKEN` | Terraform Cloud token | Variable | ✓ | ✓ |
   | `TFE_ORGANIZATION` | Your TF org name | Variable | ✓ | ✗ |

3. **Verify setup:**
   - Variables should be visible at the group level
   - They will be inherited by all projects in the group

### Step 2: Configure Local Environment (Optional)

Set up AWS credentials on your Mac for local testing:

```bash
# Run the automated setup script
cd /Users/smarticle/backstage-setup
./aws-quick-setup.sh

# The script will:
# - Install AWS CLI (if needed)
# - Configure AWS credentials
# - Set environment variables
# - Create test scripts
```

**Manual alternative:**
```bash
# Add to ~/.zshrc
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCOUNT_ID="123456789012"

# Reload shell
source ~/.zshrc

# Test connection
aws sts get-caller-identity
```

### Step 3: Configure Backstage Environment Variables

Set GitLab and Terraform tokens for Backstage:

```bash
# Add to ~/.zshrc
export GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"
export TFE_TOKEN="your-terraform-cloud-token"
export TFE_ORGANIZATION="your-terraform-org-name"

# Reload shell
source ~/.zshrc
```

**Make permanent:**
```bash
# Edit your shell config
nano ~/.zshrc

# Add the exports above, then save and reload
source ~/.zshrc
```

### Step 4: Install Backstage Template

Copy the AWS Golden Path template to your Backstage installation:

```bash
# Set your Backstage path (adjust if different)
BACKSTAGE_PATH="/Users/smarticle/backstage"

# Create templates directory
mkdir -p $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path

# Copy template files
cp -r /Users/smarticle/backstage-setup/backstage-golden-path/* \
      $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/

# Verify files copied
ls -la $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/
```

### Step 5: Update Backstage app-config.yaml

Add the template to your Backstage catalog:

```bash
# Edit Backstage config
nano $BACKSTAGE_PATH/app-config.yaml
```

Add this configuration:

```yaml
# Catalog - Template Registration
catalog:
  locations:
    # Add your AWS template
    - type: file
      target: ./templates/aws-infrastructure-golden-path/template.yaml
      rules:
        - allow: [Template]

# GitLab Integration
integrations:
  gitlab:
    - host: gitlab.com
      token: ${GITLAB_TOKEN}

# AWS Configuration (Optional - for AWS plugins)
aws:
  accounts:
    - accountId: '${AWS_ACCOUNT_ID}'
      name: 'Production'
      region: '${AWS_DEFAULT_REGION}'
      accessKeyId: ${AWS_ACCESS_KEY_ID}
      secretAccessKey: ${AWS_SECRET_ACCESS_KEY}
```

### Step 6: Start Backstage

```bash
cd $BACKSTAGE_PATH
yarn dev
```

Backstage should start at: **http://localhost:3000**

## ✅ Verification & Testing

### Test 1: Verify Template Appears

1. Open: http://localhost:3000/create
2. Look for: **"AWS Infrastructure Golden Path"**
3. Click on it to see the form

### Test 2: Create Test Project

1. Go to: http://localhost:3000/create
2. Select: **AWS Infrastructure Golden Path**
3. Fill in the form:
   - **Project Name:** `test-infrastructure`
   - **Owner:** Select yourself
   - **Environment:** `dev`
   - **AWS Region:** `us-east-1`
   - **Instance Type:** `t3.micro`
   - **GitLab Group:** Your GitLab group name
4. Click **"Create"**

### Test 3: Monitor GitLab Pipeline

1. Backstage will redirect you to the GitLab repository
2. Go to: **CI/CD → Pipelines**
3. Watch the pipeline stages:
   - ✓ Validate (Terraform format check)
   - ✓ Plan (Terraform plan)
   - ✓ Apply (Terraform apply - creates AWS resources)
   - ✓ Deploy (Application deployment)

### Test 4: Verify AWS Resources

Check that resources were created in AWS:

```bash
# List EC2 instances
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=test-infrastructure-*" \
  --region us-east-1 \
  --output table

# List VPCs
aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=test-infrastructure-*" \
  --region us-east-1 \
  --output table

# Check all resources by project tag
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=ManagedBy,Values=Terraform \
  --region us-east-1
```

### Test 5: View in Backstage Catalog

1. Go to: http://localhost:3000/catalog
2. Find your project: `test-infrastructure`
3. Click to view details
4. Links should show:
   - GitLab Repository
   - GitLab CI Pipeline
   - Catalog Entry

## 🔧 Troubleshooting

### Issue: Template Not Appearing in Backstage

**Solution:**
```bash
# Check Backstage logs
cd $BACKSTAGE_PATH
yarn dev 2>&1 | grep -i template

# Verify template file exists
ls -la templates/aws-infrastructure-golden-path/template.yaml

# Check app-config.yaml has correct path
grep -A 5 "catalog:" app-config.yaml
```

### Issue: GitLab Pipeline Fails - AWS Credentials

**Solution:**
```bash
# Verify variables are set in GitLab
# Go to: Settings → CI/CD → Variables
# Ensure AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are present

# Add debug job to .gitlab-ci.yml:
debug-aws:
  stage: .pre
  script:
    - echo "AWS_REGION=$AWS_REGION"
    - echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID"
    - aws --version
    - aws sts get-caller-identity
```

### Issue: Terraform Apply Fails - Permission Denied

**Solution:**
```bash
# Check IAM permissions
aws iam get-user

# Test specific permissions
aws ec2 describe-instances --region us-east-1
aws ec2 describe-vpcs --region us-east-1

# Your IAM user needs these permissions:
# - AmazonEC2FullAccess
# - AmazonVPCFullAccess
# - AmazonEKSClusterPolicy (if using EKS)
```

### Issue: Local AWS CLI Not Working

**Solution:**
```bash
# Check environment variables
env | grep AWS

# Reconfigure AWS CLI
aws configure

# Test connection
aws sts get-caller-identity
```

### Issue: Backstage Can't Connect to GitLab

**Solution:**
```bash
# Verify GitLab token
echo $GITLAB_TOKEN

# Test token manually
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://gitlab.com/api/v4/user"

# Regenerate token if needed:
# GitLab → Settings → Access Tokens → Create
# Scopes needed: api, write_repository
```

## 🧹 Cleanup Test Resources

After testing, clean up AWS resources to avoid charges:

```bash
# Option 1: Via Terraform (from GitLab repo)
cd test-infrastructure/terraform
terraform destroy -auto-approve

# Option 2: Via AWS CLI
# Delete EC2 instances
aws ec2 terminate-instances \
  --instance-ids i-xxxxxxxxx \
  --region us-east-1

# Delete VPC (after instances terminated)
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=test-infrastructure-vpc" \
  --query 'Vpcs[0].VpcId' --output text)
aws ec2 delete-vpc --vpc-id $VPC_ID --region us-east-1
```

## 📚 Additional Documentation

- **[AWS-INTEGRATION-GUIDE.md](AWS-INTEGRATION-GUIDE.md)** - Detailed AWS setup guide
- **[AWS-QUICK-REFERENCE.md](AWS-QUICK-REFERENCE.md)** - Command reference
- **[backstage-golden-path/README.md](backstage-golden-path/README.md)** - Template overview
- **[backstage-golden-path/SETUP-INSTRUCTIONS.md](backstage-golden-path/SETUP-INSTRUCTIONS.md)** - Detailed template installation

## 🎯 What Each Component Does

### Backstage
- Provides web UI for infrastructure creation
- Collects user input via forms
- Creates GitLab repository with Terraform code
- Registers projects in software catalog

### GitLab
- Stores infrastructure code (Terraform files)
- Triggers CI/CD pipelines automatically
- Stores AWS credentials securely
- Tracks infrastructure changes via git history

### Terraform
- Defines infrastructure as code
- Plans infrastructure changes
- Provisions AWS resources
- Maintains state of infrastructure

### AWS
- Hosts the actual infrastructure
- Provides compute (EC2), networking (VPC), containers (EKS)
- Charges based on resource usage

## 🔐 Security Best Practices

1. **Never commit AWS credentials to git**
   - Always use environment variables or CI/CD variables
   - Add `.env` to `.gitignore`

2. **Use IAM roles in production**
   - For EC2: Attach IAM role to instance
   - For EKS: Use IRSA (IAM Roles for Service Accounts)

3. **Rotate access keys regularly**
   ```bash
   # Every 90 days
   aws iam create-access-key --user-name backstage
   # Update GitLab variables
   aws iam delete-access-key --access-key-id OLD_KEY
   ```

4. **Enable MFA on AWS root account**
   ```bash
   # AWS Console → IAM → Users → Security credentials
   ```

5. **Use least privilege permissions**
   - Only grant permissions needed for templates
   - Review IAM policies regularly

## 📊 Expected Results

After successful setup, you should be able to:

- ✅ See AWS Golden Path template in Backstage UI
- ✅ Fill form and click Create
- ✅ GitLab repository created automatically
- ✅ GitLab CI pipeline runs successfully
- ✅ AWS resources provisioned (VPC, EC2, etc.)
- ✅ Project visible in Backstage catalog
- ✅ Pipeline status visible in Backstage

## 🚀 Next Steps

Once setup is complete:

1. **Create more templates** for different architectures
2. **Install AWS plugins** to view resources in Backstage
3. **Set up monitoring** for AWS resources
4. **Configure cost tracking** with AWS Cost Explorer
5. **Add approval workflows** for production deployments

## 💡 Tips

- Start with `t3.micro` instances for testing (lowest cost)
- Use `dev` environment first, then promote to `staging`/`production`
- Monitor AWS costs regularly in billing dashboard
- Tag all resources with `ManagedBy: Terraform` for tracking
- Use Terraform state locking for team collaboration

## 📞 Support & Resources

- **Backstage Docs:** https://backstage.io/docs
- **GitLab CI Docs:** https://docs.gitlab.com/ee/ci/
- **Terraform AWS Provider:** https://registry.terraform.io/providers/hashicorp/aws
- **AWS CLI Reference:** https://docs.aws.amazon.com/cli/

---

**Last Updated:** February 20, 2026  
**Version:** 1.0.0  
**Maintained by:** Platform Team

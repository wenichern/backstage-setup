# AWS + Backstage Quick Reference

## 🚀 Quick Setup (5 minutes)

```bash
# 1. Run the automated setup
cd /Users/smarticle/backstage-setup
./aws-quick-setup.sh

# 2. Reload shell
source ~/.zshrc

# 3. Test AWS connection
aws sts get-caller-identity

# 4. Done! Open Backstage
# http://localhost:3000/create
```

## 🔑 AWS Credentials Setup

### Method 1: AWS CLI (Recommended)
```bash
# Install AWS CLI (Mac)
brew install awscli

# Configure credentials
aws configure
# Enter: Access Key ID
# Enter: Secret Access Key
# Enter: Region (us-east-1)
# Enter: Output format (json)

# Test
aws sts get-caller-identity
```

### Method 2: Environment Variables
```bash
# Add to ~/.zshrc
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCY"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCOUNT_ID="123456789012"

# Reload
source ~/.zshrc
```

### Method 3: IAM Role (Production)
```bash
# For EC2 instances - attach IAM role
# No credentials needed in environment

# Verify
aws sts get-caller-identity
# Should show role ARN
```

## 📝 Backstage Configuration

### Add to app-config.yaml
```yaml
aws:
  accounts:
    - accountId: '${AWS_ACCOUNT_ID}'
      name: 'Production'
      region: 'us-east-1'
      accessKeyId: ${AWS_ACCESS_KEY_ID}
      secretAccessKey: ${AWS_SECRET_ACCESS_KEY}
```

### Install AWS Plugins
```bash
cd /Users/smarticle/backstage

# Lambda plugin
yarn --cwd packages/app add @backstage-community/plugin-aws-lambda
yarn --cwd packages/backend add @backstage-community/plugin-aws-lambda-backend

# AWS Apps plugin (ECS, RDS, S3)
yarn --cwd packages/app add @roadiehq/backstage-plugin-aws

# Rebuild
yarn dev
```

## 🔧 GitLab CI Variables

### Add to GitLab Project
**Settings → CI/CD → Variables**

| Variable | Value | Flags |
|----------|-------|-------|
| `AWS_ACCESS_KEY_ID` | Your access key | Protected, Masked |
| `AWS_SECRET_ACCESS_KEY` | Your secret key | Protected, Masked |
| `AWS_DEFAULT_REGION` | us-east-1 | Protected |
| `AWS_ACCOUNT_ID` | 123456789012 | Protected |
| `TFE_TOKEN` | Terraform token | Protected, Masked |
| `TFE_ORGANIZATION` | Your TF org | Protected |

### Test in GitLab CI
```yaml
# .gitlab-ci.yml
test-aws:
  script:
    - aws sts get-caller-identity
    - aws ec2 describe-regions --region $AWS_REGION
```

## ✅ Testing Commands

### Test AWS Credentials
```bash
# Check environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_DEFAULT_REGION

# Verify identity
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDAI...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/backstage"
# }
```

### Test AWS Permissions
```bash
# EC2 access
aws ec2 describe-instances --region us-east-1

# VPC access
aws ec2 describe-vpcs --region us-east-1

# EKS access
aws eks list-clusters --region us-east-1

# S3 access
aws s3 ls

# IAM access
aws iam get-user
```

### Test Terraform
```bash
cd backstage-template-content/terraform

# Initialize
terraform init

# Plan (dry run)
terraform plan \
  -var="project_name=test" \
  -var="environment=dev" \
  -var="aws_region=us-east-1"

# Apply (actually create resources)
terraform apply \
  -var="project_name=test" \
  -var="environment=dev" \
  -var="aws_region=us-east-1"

# Destroy (clean up)
terraform destroy \
  -var="project_name=test" \
  -var="environment=dev" \
  -var="aws_region=us-east-1"
```

### Test Backstage Template
```bash
# Start Backstage
cd /Users/smarticle/backstage
yarn dev

# Open browser
open http://localhost:3000/create

# Select: AWS Infrastructure Golden Path
# Fill form and create
```

## 🔍 Troubleshooting Commands

### Issue: Credentials Not Found
```bash
# Check environment
env | grep AWS

# Check AWS config files
cat ~/.aws/credentials
cat ~/.aws/config

# Re-configure
aws configure
```

### Issue: Permission Denied
```bash
# Check user
aws sts get-caller-identity

# List user policies
USER_NAME=$(aws sts get-caller-identity --query Arn --output text | cut -d'/' -f2)
aws iam list-attached-user-policies --user-name $USER_NAME
aws iam list-user-policies --user-name $USER_NAME

# Test specific permission
aws ec2 describe-vpcs --region us-east-1 --debug
```

### Issue: GitLab CI Fails
```bash
# Add debug job to .gitlab-ci.yml
debug:
  script:
    - echo "AWS_REGION=$AWS_REGION"
    - echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID"
    - aws --version
    - aws sts get-caller-identity
```

### Issue: Backstage Can't Load Template
```bash
# Check template syntax
cd /Users/smarticle/backstage/templates/aws-infrastructure-golden-path
cat template.yaml

# Check Backstage logs
cd /Users/smarticle/backstage
yarn dev 2>&1 | grep -i error

# Validate catalog
curl http://localhost:7007/api/catalog/entities
```

## 📦 Required IAM Permissions

### Minimum Policy for Templates
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateVpc",
        "ec2:CreateSubnet",
        "ec2:CreateSecurityGroup",
        "ec2:CreateInternetGateway",
        "ec2:CreateRouteTable",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": "*"
    }
  ]
}
```

### Policy for EKS
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:CreateCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:DeleteCluster",
        "iam:CreateRole",
        "iam:AttachRolePolicy"
      ],
      "Resource": "*"
    }
  ]
}
```

### Create IAM User for Backstage
```bash
# Create user
aws iam create-user --user-name backstage-service

# Create access key
aws iam create-access-key --user-name backstage-service

# Attach policies
aws iam attach-user-policy \
  --user-name backstage-service \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

aws iam attach-user-policy \
  --user-name backstage-service \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
```

## 🔐 Security Best Practices

### Rotate Access Keys
```bash
# Create new key
aws iam create-access-key --user-name backstage-service

# Update .zshrc with new credentials
nano ~/.zshrc

# Reload shell
source ~/.zshrc

# Delete old key
aws iam delete-access-key \
  --user-name backstage-service \
  --access-key-id OLD_KEY_ID
```

### Use AWS Secrets Manager
```bash
# Store secret
aws secretsmanager create-secret \
  --name backstage/terraform-token \
  --secret-string "your-token"

# Retrieve secret
aws secretsmanager get-secret-value \
  --secret-id backstage/terraform-token \
  --query SecretString \
  --output text
```

### Audit AWS Activity
```bash
# View CloudTrail events
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue=backstage-service \
  --max-results 50

# View recent API calls
aws cloudtrail lookup-events \
  --start-time $(date -u -v-1H +%Y-%m-%dT%H:%M:%S) \
  --output table
```

## 🎯 Common Workflows

### Workflow 1: Create New Project
```bash
# 1. Open Backstage
open http://localhost:3000/create

# 2. Select template: AWS Infrastructure Golden Path

# 3. Fill form:
#    - Project Name: my-app
#    - Environment: dev
#    - AWS Region: us-east-1
#    - Instance Type: t3.small

# 4. Click "Create"

# 5. Monitor GitLab pipeline
open https://gitlab.com/your-group/my-app/-/pipelines

# 6. Verify in AWS Console
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=my-app-*" \
  --output table
```

### Workflow 2: Update Infrastructure
```bash
# 1. Clone project
git clone https://gitlab.com/your-group/my-app.git
cd my-app

# 2. Modify Terraform
nano terraform/main.tf

# 3. Commit and push
git add .
git commit -m "Update infrastructure"
git push

# 4. GitLab CI automatically runs
# 5. Check pipeline status
```

### Workflow 3: Destroy Resources
```bash
# Option 1: via Terraform directly
cd my-app/terraform
terraform destroy -auto-approve

# Option 2: via GitLab CI
# Add manual job to .gitlab-ci.yml:
# destroy:
#   stage: cleanup
#   script:
#     - cd terraform
#     - terraform destroy -auto-approve
#   when: manual
```

## 📚 Quick Links

- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [Backstage Templates](https://backstage.io/docs/features/software-templates/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)

## 🆘 Get Help

```bash
# AWS CLI help
aws help
aws ec2 help
aws sts help

# Check Backstage logs
cd /Users/smarticle/backstage
yarn dev 2>&1 | tee backstage.log

# Check GitLab CI logs
# Visit: https://gitlab.com/your-group/project/-/pipelines
```

## 📞 Support Contacts

- AWS Support: https://console.aws.amazon.com/support
- Backstage Discord: https://discord.gg/backstage
- GitLab Support: https://about.gitlab.com/support/

---

**Last Updated:** February 2026
**Version:** 1.0

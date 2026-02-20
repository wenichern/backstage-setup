# AWS Account Integration with Backstage

Complete guide to sync and integrate your AWS account with Backstage open source.

## 🎯 Quick Start - Minimum Required Setup

### Step 1: Set AWS Credentials

**Option A: Local Development (Mac)**
```bash
# Add to ~/.zshrc
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCOUNT_ID="123456789012"

# Reload shell
source ~/.zshrc
```

**Option B: AWS CLI Configuration** (Alternative)
```bash
# Install AWS CLI if needed
brew install awscli

# Configure AWS credentials
aws configure
# Enter: Access Key ID
# Enter: Secret Access Key
# Enter: Default region (us-east-1)
# Enter: Default output format (json)

# Verify
aws sts get-caller-identity
```

### Step 2: Update Backstage app-config.yaml

Add AWS configuration to your Backstage `app-config.yaml`:

```yaml
# AWS Configuration
aws:
  accounts:
    - accountId: '${AWS_ACCOUNT_ID}'
      name: 'Primary AWS Account'
      region: '${AWS_DEFAULT_REGION}'
      accessKeyId: ${AWS_ACCESS_KEY_ID}
      secretAccessKey: ${AWS_SECRET_ACCESS_KEY}

# Scaffolder secrets (for templates)
scaffolder:
  defaultAuthor:
    name: Backstage
    email: backstage@yourcompany.com

# Store secrets
integrations:
  gitlab:
    - host: gitlab.com
      token: ${GITLAB_TOKEN}

# Proxy for AWS API calls
proxy:
  '/aws-api':
    target: 'https://aws.amazon.com'
    changeOrigin: true
```

### Step 3: Configure GitLab CI Variables for AWS

In your GitLab project, add these CI/CD variables:

1. Go to: **Settings → CI/CD → Variables**
2. Add the following:

```
AWS_ACCESS_KEY_ID          = AKIAIOSFODNN7EXAMPLE (Protected, Masked)
AWS_SECRET_ACCESS_KEY      = wJalrXUtn... (Protected, Masked)
AWS_DEFAULT_REGION         = us-east-1
AWS_ACCOUNT_ID             = 123456789012
TFE_TOKEN                  = your-terraform-token (Protected, Masked)
TFE_ORGANIZATION           = your-terraform-org
```

## 🔧 Advanced Setup - Full AWS Integration

### Install AWS Plugins

**1. AWS Lambda Plugin**
```bash
cd /Users/smarticle/backstage  # Your Backstage directory

# Add frontend plugin
yarn --cwd packages/app add @backstage-community/plugin-aws-lambda

# Add backend plugin
yarn --cwd packages/backend add @backstage-community/plugin-aws-lambda-backend
```

Update `packages/app/src/App.tsx`:
```typescript
import { AwsLambdaPage } from '@backstage-community/plugin-aws-lambda';

// Add route
<Route path="/aws-lambda" element={<AwsLambdaPage />} />
```

**2. AWS Apps Plugin (ECS, RDS, S3)**
```bash
yarn --cwd packages/app add @roadiehq/backstage-plugin-aws
```

**3. AWS Cost Insights**
```bash
yarn --cwd packages/app add @backstage-community/plugin-cost-insights
```

### Create AWS IAM Role for Backstage

**Option: IAM Role (Recommended for Production)**

1. Create IAM policy for Backstage:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "eks:Describe*",
        "eks:List*",
        "lambda:Get*",
        "lambda:List*",
        "s3:List*",
        "s3:GetBucketLocation",
        "rds:Describe*",
        "ecs:Describe*",
        "ecs:List*",
        "cloudformation:Describe*",
        "cloudformation:List*",
        "iam:GetRole",
        "iam:ListRoles",
        "sts:GetCallerIdentity",
        "ce:GetCostAndUsage"
      ],
      "Resource": "*"
    }
  ]
}
```

2. Create IAM role with this policy attached
3. Note the Role ARN: `arn:aws:iam::123456789012:role/BackstageRole`
4. Update app-config.yaml:

```yaml
aws:
  accounts:
    - accountId: '123456789012'
      roleArn: 'arn:aws:iam::123456789012:role/BackstageRole'
```

## 🚀 Testing Your AWS Integration

### Test 1: Verify AWS Credentials
```bash
# In terminal where you run Backstage
echo $AWS_ACCESS_KEY_ID
aws sts get-caller-identity
```

Expected output:
```json
{
    "UserId": "AIDAI...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/backstage"
}
```

### Test 2: Run Your Template

1. Open Backstage: http://localhost:3000
2. Go to: **Create... → AWS Infrastructure Golden Path**
3. Fill in the form:
   - Project Name: `test-project`
   - Environment: `dev`
   - AWS Region: `us-east-1`
   - Instance Type: `t3.micro`
4. Click **Create**
5. Monitor the pipeline in GitLab

### Test 3: Verify Terraform Can Access AWS

Add a test step to your GitLab CI:

```yaml
# Add to .gitlab-ci.yml
test-aws-connection:
  stage: .pre
  script:
    - apk add --no-cache aws-cli
    - aws sts get-caller-identity
    - aws ec2 describe-regions --region $AWS_REGION
  only:
    - branches
```

## 📝 Security Best Practices

### 1. Use AWS IAM Roles (Not Access Keys) in Production

For EC2-hosted Backstage:
```bash
# Attach IAM role to EC2 instance
# No need for AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY
```

For EKS-hosted Backstage:
```yaml
# Use IAM Roles for Service Accounts (IRSA)
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/backstage-role
```

### 2. Rotate Access Keys Regularly

```bash
# Create new access key
aws iam create-access-key --user-name backstage-user

# Update environment variables with new key
export AWS_ACCESS_KEY_ID="new-key"
export AWS_SECRET_ACCESS_KEY="new-secret"

# Delete old access key
aws iam delete-access-key --access-key-id OLD_KEY --user-name backstage-user
```

### 3. Use Least Privilege Permissions

Only grant permissions needed for your templates:
- EC2: `ec2:RunInstances`, `ec2:DescribeInstances`
- VPC: `ec2:CreateVpc`, `ec2:CreateSubnet`
- EKS: `eks:CreateCluster`, `eks:DescribeCluster`

### 4. Encrypt Secrets

**Use AWS Secrets Manager:**
```bash
# Store Terraform token in AWS Secrets Manager
aws secretsmanager create-secret \
  --name backstage/terraform-token \
  --secret-string "your-tfe-token"

# Retrieve in GitLab CI
export TFE_TOKEN=$(aws secretsmanager get-secret-value \
  --secret-id backstage/terraform-token \
  --query SecretString --output text)
```

## 🔍 Troubleshooting

### Issue 1: "Unable to locate credentials"

**Solution:**
```bash
# Verify environment variables are set
env | grep AWS

# If using AWS CLI profile
export AWS_PROFILE=default
aws configure list
```

### Issue 2: "Access Denied" errors in Terraform

**Solution:**
```bash
# Check IAM permissions
aws iam get-user
aws iam list-attached-user-policies --user-name backstage-user

# Test specific permission
aws ec2 describe-vpcs --region us-east-1
```

### Issue 3: GitLab CI can't access AWS

**Solution:**
1. Check GitLab CI variables are set (Settings → CI/CD → Variables)
2. Ensure variables are not marked as "Protected" if running on non-protected branches
3. Add debug step to .gitlab-ci.yml:

```yaml
debug-aws:
  script:
    - echo "AWS Region: $AWS_REGION"
    - echo "AWS Account: $AWS_ACCOUNT_ID"
    - aws sts get-caller-identity
```

### Issue 4: Backstage can't find AWS resources

**Solution:**
```bash
# Install AWS plugins
cd $BACKSTAGE_PATH
yarn --cwd packages/backend add @backstage-community/plugin-aws-lambda-backend

# Restart Backstage
yarn dev
```

## 📚 Additional Resources

### AWS + Backstage Documentation
- [Backstage AWS Lambda Plugin](https://github.com/backstage/community-plugins/tree/main/workspaces/aws-lambda)
- [Roadie AWS Plugin](https://roadie.io/backstage/plugins/aws/)
- [Terraform Cloud Integration](https://www.terraform.io/cloud-docs/api-docs)

### AWS IAM Best Practices
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Using IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use.html)

### GitLab CI + AWS
- [GitLab CI Environment Variables](https://docs.gitlab.com/ee/ci/variables/)
- [Using AWS with GitLab CI](https://docs.gitlab.com/ee/ci/cloud_deployment/)

## ✅ Checklist

Before using your AWS golden path template:

- [ ] AWS credentials set in environment variables
- [ ] AWS CLI configured and tested (`aws sts get-caller-identity`)
- [ ] IAM permissions verified (EC2, VPC, EKS as needed)
- [ ] GitLab CI variables configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
- [ ] Terraform Cloud token set (TFE_TOKEN)
- [ ] Backstage app-config.yaml updated with AWS configuration
- [ ] GitLab integration token set (GITLAB_TOKEN)
- [ ] Template visible in Backstage UI (http://localhost:3000/create)
- [ ] Test project created successfully
- [ ] AWS resources created in your account

## 🎉 Next Steps

Once AWS is integrated:

1. **Create your first project** using the golden path template
2. **Monitor the GitLab pipeline** to see infrastructure being created
3. **Check AWS Console** to verify resources (VPC, EC2, etc.)
4. **Add more templates** for different AWS architectures
5. **Install AWS plugins** to view resources in Backstage
6. **Set up Cost Insights** to track spending

---

**Need help?** Check the logs:
```bash
# Backstage logs
cd /Users/smarticle/backstage
yarn dev 2>&1 | tee backstage.log

# AWS CLI debug
aws ec2 describe-instances --region us-east-1 --debug
```

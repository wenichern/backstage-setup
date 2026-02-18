# Backstage Golden Path Installation Guide

Complete guide to set up Backstage Golden Path template with GitLab CI, Terraform Enterprise, and AWS infrastructure provisioning.

## Architecture Flow

```
Backstage Golden Path Template
        ↓
GitLab CI pipeline starts automatically
        ↓
Stage 1: Terraform Enterprise provisions infrastructure
        ↓
Stage 2: GitLab CI runs install scripts on new infrastructure
        (SSH, Helm charts, kubectl, Docker, etc.)
        ↓
Backstage shows pipeline status in real-time
```

## Prerequisites

### 1. **Backstage Setup** (Already Running on EC2)
- Backstage running at `http://localhost:3000`
- SSH access to EC2 instance

### 2. **Required Accounts & Services**
- GitLab account with CI/CD enabled
- Terraform Enterprise/Cloud account
- AWS account with appropriate permissions

### 3. **Required Tokens**
- GitLab Personal Access Token (with `api`, `read_repository`, `write_repository` scopes)
- Terraform Enterprise API token
- AWS credentials

## Installation Steps

### Step 1: SSH into Backstage EC2 Instance

```bash
ssh -i your-key.pem ec2-user@your-ec2-ip
cd /path/to/backstage
```

### Step 2: Install Backstage Template

```bash
# Navigate to Backstage directory
cd /path/to/backstage

# Create templates directory if it doesn't exist
mkdir -p templates/aws-infrastructure-golden-path

# Copy the template files
# You'll need to transfer the files from your local machine
```

**Transfer files to EC2:**
```bash
# From your local machine
scp -i your-key.pem backstage-golden-path-template.yaml ec2-user@your-ec2-ip:/path/to/backstage/templates/aws-infrastructure-golden-path/template.yaml

scp -r -i your-key.pem backstage-template-content/* ec2-user@your-ec2-ip:/path/to/backstage/templates/aws-infrastructure-golden-path/content/
```

### Step 3: Update Backstage Configuration

Edit `app-config.yaml` in your Backstage root directory:

```yaml
# Add to app-config.yaml

# Catalog locations
catalog:
  locations:
    # Existing locations...
    
    # Add golden path template
    - type: file
      target: ./templates/aws-infrastructure-golden-path/template.yaml
      rules:
        - allow: [Template]

# GitLab integration
integrations:
  gitlab:
    - host: gitlab.com
      token: ${GITLAB_TOKEN}  # Set as environment variable

# Terraform Enterprise integration (if using backstage-plugin-terraform)
terraform:
  organization: ${TFE_ORGANIZATION}
  token: ${TFE_TOKEN}

# Secret management (for secure tokens)
# Use environment variables or AWS Secrets Manager
```

### Step 4: Set Environment Variables

Create a `.env` file in Backstage root:

```bash
# .env file
export GITLAB_TOKEN="your-gitlab-token"
export TFE_TOKEN="your-terraform-cloud-token"
export TFE_ORGANIZATION="your-tfe-org-name"
export AWS_ACCESS_KEY_ID="your-aws-access-key"
export AWS_SECRET_ACCESS_KEY="your-aws-secret-key"
export AWS_REGION="us-east-1"
```

Load environment variables:
```bash
source .env
```

### Step 5: Install Required Backstage Plugins

```bash
cd /path/to/backstage

# Install GitLab plugin (if not already installed)
yarn add --cwd packages/app @backstage/plugin-scaffolder-backend-module-gitlab

# Install pipeline visualization plugin
yarn add --cwd packages/app @immobiliarelabs/backstage-plugin-gitlab-pipelines

# Install Terraform plugin (optional, for TFE integration)
yarn add --cwd packages/app @backstage-community/plugin-terraform
```

### Step 6: Configure Scaffolder Actions

Edit `packages/backend/src/plugins/scaffolder.ts`:

```typescript
import { ScmIntegrations } from '@backstage/integration';
import {
  createBuiltinActions,
  createRouter,
} from '@backstage/plugin-scaffolder-backend';
import { Router } from 'express';
import type { PluginEnvironment } from '../types';
import { createGitlabGroupAction } from '@backstage/plugin-scaffolder-backend-module-gitlab';

export default async function createPlugin(
  env: PluginEnvironment,
): Promise<Router> {
  const catalogClient = new CatalogClient({
    discoveryApi: env.discovery,
  });

  const integrations = ScmIntegrations.fromConfig(env.config);
  
  const builtInActions = createBuiltinActions({
    integrations,
    catalogClient,
    config: env.config,
    reader: env.reader,
  });

  // Add custom actions
  const actions = [
    ...builtInActions,
    createGitlabGroupAction({ integrations }),
    // Add more custom actions as needed
  ];

  return await createRouter({
    actions,
    catalogClient,
    logger: env.logger,
    config: env.config,
    database: env.database,
    reader: env.reader,
  });
}
```

### Step 7: Configure GitLab CI Variables in Template

Update GitLab to use CI/CD variables. In GitLab, go to:
- Settings → CI/CD → Variables
- Add the following variables:
  - `TFE_TOKEN` (masked)
  - `TFE_ORGANIZATION`
  - `SSH_PRIVATE_KEY` (masked, for EC2 access)
  - `KUBECONFIG_CONTENT` (base64 encoded, if using Kubernetes)

### Step 8: Restart Backstage

```bash
cd /path/to/backstage

# Build the app
yarn build

# Start Backstage
yarn start
```

Or if using PM2:
```bash
pm2 restart backstage
```

### Step 9: Verify Template is Loaded

1. Open browser: `http://localhost:3000`
2. Navigate to "Create" → "Choose a template"
3. You should see "AWS Infrastructure Golden Path"

## Using the Golden Path Template

### 1. Create New Project

1. Go to Backstage → **Create**
2. Select **AWS Infrastructure Golden Path**
3. Fill in the form:
   - **Project Name**: `my-awesome-app`
   - **Owner**: Select team/user
   - **Environment**: `dev`
   - **AWS Region**: `us-east-1`
   - **Instance Type**: `t3.small`
   - **Enable Kubernetes**: Yes/No

4. Click **Create**

### 2. Monitor Pipeline Progress

After creation, you'll see:
- Link to GitLab repository
- Link to GitLab CI pipeline
- Link to Backstage catalog

**GitLab CI Pipeline stages:**
1. ✅ Validate - Terraform validation
2. ✅ Plan - Terraform plan
3. ⏸️ Provision - Manual approval, then Terraform apply
4. ✅ Deploy - SSH to EC2, install Docker/kubectl/Helm, deploy app
5. ✅ Verify - Health checks

### 3. View in Backstage

Navigate to the new component in Backstage catalog to see:
- Overview
- CI/CD pipelines
- Terraform state
- AWS resources
- Documentation

## File Structure

```
backstage/
├── templates/
│   └── aws-infrastructure-golden-path/
│       ├── template.yaml                 # Main template definition
│       └── content/
│           ├── catalog-info.yaml         # Backstage catalog entry
│           ├── .gitlab-ci.yml            # GitLab CI pipeline
│           ├── terraform/
│           │   ├── main.tf               # Infrastructure as Code
│           │   ├── variables.tf          # Terraform variables
│           │   └── outputs.tf            # Terraform outputs
│           └── scripts/
│               ├── install-docker.sh     # Docker installation
│               ├── install-kubectl.sh    # kubectl installation
│               ├── install-helm.sh       # Helm installation
│               └── deploy-app.sh         # Application deployment
└── app-config.yaml                       # Backstage configuration
```

## Troubleshooting

### Issue: Template not showing in Backstage

**Solution:**
```bash
# Check if template is valid
yarn backstage-cli repo validate-template templates/aws-infrastructure-golden-path/template.yaml

# Reload catalog
curl -X POST http://localhost:3000/api/catalog/refresh
```

### Issue: GitLab integration not working

**Solution:**
- Verify `GITLAB_TOKEN` has correct permissions
- Check GitLab is configured in `app-config.yaml`
- Ensure GitLab plugin is installed

### Issue: Terraform Enterprise connection fails

**Solution:**
- Verify `TFE_TOKEN` is valid
- Check TFE organization name is correct
- Ensure backend configuration in `.gitlab-ci.yml` matches your TFE setup

### Issue: SSH to EC2 fails in GitLab CI

**Solution:**
- Add SSH private key to GitLab CI variables
- Ensure EC2 security group allows SSH from GitLab runners
- Verify key pair matches the one used in Terraform

### Issue: Pipeline shows "pending" for manual stage

**Solution:**
- This is expected! Navigate to GitLab pipeline and manually approve the `terraform-apply` stage
- This ensures infrastructure changes are reviewed before applying

## Advanced Configuration

### Add Custom Terraform Modules

Create custom modules in `content/terraform/modules/`:

```hcl
# content/terraform/modules/rds/main.tf
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-db"
  # ... RDS configuration
}
```

Reference in main.tf:
```hcl
module "database" {
  source = "./modules/rds"
  project_name = var.project_name
}
```

### Add Kubernetes Helm Charts

Create Helm chart in `content/helm/`:

```yaml
# content/helm/Chart.yaml
apiVersion: v2
name: myapp
version: 1.0.0

# content/helm/values.yaml
replicaCount: 2
image:
  repository: myapp
  tag: latest
```

### Integrate with Backstage TechDocs

Add documentation in `content/docs/`:

```markdown
# content/docs/index.md
# My Application

## Architecture
...
```

Update `catalog-info.yaml`:
```yaml
metadata:
  annotations:
    backstage.io/techdocs-ref: dir:.
```

## Pipeline Visualization in Backstage

Install pipeline visualization:

```yaml
# app-config.yaml
gitlab:
  proxyPath: /gitlab/api
  allowedKinds: ['Component', 'Resource']
```

Then in your component, you'll see pipeline status directly in Backstage!

## Monitoring Costs

Add cost tracking:

```yaml
# catalog-info.yaml
metadata:
  annotations:
    aws.amazon.com/cost-center: "engineering"
```

Integrate with AWS Cost Explorer for cost visibility in Backstage.

## Security Best Practices

1. **Use AWS Secrets Manager** for sensitive values
2. **Rotate tokens** regularly
3. **Use IAM roles** instead of access keys when possible
4. **Enable MFA** on AWS accounts
5. **Review security groups** - don't use 0.0.0.0/0 in production

## Next Steps

- Add more environment options (staging, production)
- Integrate with monitoring (CloudWatch, Datadog)
- Add automated testing stages
- Implement blue/green deployments
- Add rollback capabilities

## Additional Resources

- [Backstage Software Templates](https://backstage.io/docs/features/software-templates/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)

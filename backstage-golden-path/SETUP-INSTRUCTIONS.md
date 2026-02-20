# Setup Instructions for Mac Backstage POC

## Your Files Are Ready! ✅

All files are organized in:
```
/Users/smarticle/backstage-setup/backstage-golden-path/
├── template.yaml
└── content/
    ├── .gitlab-ci.yml
    ├── catalog-info.yaml
    ├── terraform/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── scripts/
        ├── install-docker.sh
        ├── install-kubectl.sh
        ├── install-helm.sh
        └── deploy-app.sh
```

## How to Make It Show in localhost:3000

### Step 1: Copy to Your Backstage Installation

Find where you installed Backstage on your Mac. It's likely one of these:
- `/Users/smarticle/backstage`
- `/Users/smarticle/my-backstage-app`
- Or where you ran `npx @backstage/create-app`

**Find it:**
```bash
# Option 1: Check recent directories
ls -la ~ | grep backstage

# Option 2: Check if you have a standard location
ls -la /Users/smarticle/backstage 2>/dev/null && echo "Found!"
```

### Step 2: Copy Template Files

Let's say your Backstage is at `/Users/smarticle/backstage` (adjust path as needed):

```bash
# Set your Backstage path
BACKSTAGE_PATH="/Users/smarticle/backstage"

# Create templates directory
mkdir -p $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path

# Copy all files
cp -r /Users/smarticle/backstage-setup/backstage-golden-path/* \
      $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/

# Verify
ls -la $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/content/
```

### Step 3: Update app-config.yaml

Edit `$BACKSTAGE_PATH/app-config.yaml` and add:

```yaml
# Add under catalog → locations section
catalog:
  locations:
    # ... existing locations ...
    
    # Add this:
    - type: file
      target: ./templates/aws-infrastructure-golden-path/template.yaml
      rules:
        - allow: [Template]

# Add GitLab integration (if not already present)
integrations:
  gitlab:
    - host: gitlab.com
      token: ${GITLAB_TOKEN}  # Will set this as environment variable
```

### Step 4: Set Environment Variables

In your terminal where you run Backstage:

```bash
# Set these before starting Backstage
export GITLAB_TOKEN="your-gitlab-personal-access-token"
export TFE_TOKEN="your-terraform-cloud-token"
export TFE_ORGANIZATION="your-terraform-org-name"
```

To make permanent, add to `~/.zshrc`:
```bash
echo 'export GITLAB_TOKEN="glpat-xxxxxxxxxxxx"' >> ~/.zshrc
echo 'export TFE_TOKEN="your-tfe-token"' >> ~/.zshrc
echo 'export TFE_ORGANIZATION="your-org"' >> ~/.zshrc
source ~/.zshrc
```

### Step 5: Restart Backstage

```bash
# Navigate to Backstage directory
cd $BACKSTAGE_PATH

# If Backstage is running, stop it (Ctrl+C)
# Then restart:
yarn dev
```

### Step 6: Verify in Browser

1. Open `http://localhost:3000`
2. Click **"Create"** in the left sidebar
3. Look for **"AWS Infrastructure Golden Path"** template
4. If you see it → ✅ Success!

## Troubleshooting

### Template Not Showing?

```bash
# Check if file exists
ls -la $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/template.yaml

# Check catalog configuration
grep -A 5 "catalog:" $BACKSTAGE_PATH/app-config.yaml

# Force catalog refresh
curl -X POST http://localhost:3000/api/catalog/refresh
```

### Need to Find Your Backstage Directory?

```bash
# Check running processes
ps aux | grep "backstage\|yarn\|node" | grep -v grep

# Check where node is running from
lsof -i :3000 | grep LISTEN
```

### GitLab Plugin Not Installed?

```bash
cd $BACKSTAGE_PATH
yarn add --cwd packages/backend @backstage/plugin-scaffolder-backend-module-gitlab
yarn build
```

## Quick Copy Script

Here's a complete script to copy when you find your Backstage path:

```bash
#!/bin/bash

# SET YOUR BACKSTAGE PATH HERE:
BACKSTAGE_PATH="/Users/smarticle/backstage"  # CHANGE THIS!

# Create templates directory
echo "Creating templates directory..."
mkdir -p $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path

# Copy files
echo "Copying template files..."
cp -r /Users/smarticle/backstage-setup/backstage-golden-path/* \
      $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/

# Verify
echo "Verifying files..."
ls -la $BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/

echo "✅ Done! Now:"
echo "1. Update $BACKSTAGE_PATH/app-config.yaml (see Step 3 above)"
echo "2. Set environment variables (Step 4)"
echo "3. Restart Backstage: cd $BACKSTAGE_PATH && yarn dev"
echo "4. Go to http://localhost:3000 and click 'Create'"
```

## What Happens When You Use It?

1. Fill form in Backstage UI
2. Backstage creates GitLab repo with all your files
3. GitLab CI pipeline starts automatically
4. Terraform provisions AWS infrastructure
5. Scripts deploy applications
6. You see status in Backstage!

## Need Help?

Check full documentation: `backstage-golden-path-installation.md`

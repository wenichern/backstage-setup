#!/bin/bash

echo "🚀 Backstage Golden Path Setup Script"
echo "======================================="
echo ""

# Step 1: Find Backstage installation
echo "Step 1: Finding your Backstage installation..."
echo ""
echo "Common locations to check:"
echo "  1. /Users/smarticle/backstage"
echo "  2. /Users/smarticle/my-backstage-app"
echo "  3. Custom path"
echo ""

# Check common locations
if [ -d "/Users/smarticle/backstage" ] && [ -f "/Users/smarticle/backstage/app-config.yaml" ]; then
    BACKSTAGE_PATH="/Users/smarticle/backstage"
    echo "✅ Found Backstage at: $BACKSTAGE_PATH"
elif [ -d "/Users/smarticle/my-backstage-app" ] && [ -f "/Users/smarticle/my-backstage-app/app-config.yaml" ]; then
    BACKSTAGE_PATH="/Users/smarticle/my-backstage-app"
    echo "✅ Found Backstage at: $BACKSTAGE_PATH"
else
    echo "❓ Backstage not found in common locations."
    echo ""
    read -p "Enter full path to your Backstage directory: " BACKSTAGE_PATH
    
    if [ ! -d "$BACKSTAGE_PATH" ] || [ ! -f "$BACKSTAGE_PATH/app-config.yaml" ]; then
        echo "❌ Error: Invalid Backstage directory. app-config.yaml not found."
        echo "Please check the path and try again."
        exit 1
    fi
fi

echo ""
echo "Using Backstage at: $BACKSTAGE_PATH"
echo ""

# Step 2: Create templates directory
echo "Step 2: Creating templates directory..."
mkdir -p "$BACKSTAGE_PATH/templates/aws-infrastructure-golden-path"

if [ $? -eq 0 ]; then
    echo "✅ Templates directory created"
else
    echo "❌ Failed to create templates directory"
    exit 1
fi

# Step 3: Copy template files
echo ""
echo "Step 3: Copying template files..."
TEMPLATE_SOURCE="/Users/smarticle/backstage-setup/backstage-golden-path"

if [ ! -d "$TEMPLATE_SOURCE" ]; then
    echo "❌ Error: Template source not found at $TEMPLATE_SOURCE"
    exit 1
fi

cp -r "$TEMPLATE_SOURCE"/* "$BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/"

if [ $? -eq 0 ]; then
    echo "✅ Template files copied successfully"
else
    echo "❌ Failed to copy template files"
    exit 1
fi

# Step 4: Verify files
echo ""
echo "Step 4: Verifying files..."
echo ""
echo "Template structure:"
find "$BACKSTAGE_PATH/templates/aws-infrastructure-golden-path" -type f | sort
echo ""

# Check if .gitlab-ci.yml was copied
if [ -f "$BACKSTAGE_PATH/templates/aws-infrastructure-golden-path/content/.gitlab-ci.yml" ]; then
    echo "✅ All files including .gitlab-ci.yml copied successfully"
else
    echo "⚠️  Warning: .gitlab-ci.yml might be missing"
fi

# Step 5: Instructions for app-config.yaml
echo ""
echo "========================================="
echo "✅ Template files installed successfully!"
echo "========================================="
echo ""
echo "📝 Next Steps (IMPORTANT!):"
echo ""
echo "1. Update app-config.yaml:"
echo "   File: $BACKSTAGE_PATH/app-config.yaml"
echo ""
echo "   Add this under 'catalog → locations':"
cat << 'EOF'
   
   catalog:
     locations:
       # Existing locations...
       
       - type: file
         target: ./templates/aws-infrastructure-golden-path/template.yaml
         rules:
           - allow: [Template]
EOF

echo ""
echo "   Add GitLab integration (if not present):"
cat << 'EOF'
   
   integrations:
     gitlab:
       - host: gitlab.com
         token: ${GITLAB_TOKEN}
EOF

echo ""
echo "2. Set environment variables:"
echo "   export GITLAB_TOKEN='your-gitlab-token'"
echo "   export TFE_TOKEN='your-terraform-token'"
echo "   export TFE_ORGANIZATION='your-terraform-org'"
echo ""
echo "3. Restart Backstage:"
echo "   cd $BACKSTAGE_PATH"
echo "   yarn dev"
echo ""
echo "4. Open browser:"
echo "   http://localhost:3000"
echo "   Navigate to: Create → AWS Infrastructure Golden Path"
echo ""
echo "📖 For detailed instructions, see:"
echo "   $TEMPLATE_SOURCE/SETUP-INSTRUCTIONS.md"
echo ""
echo "🎉 Happy building!"

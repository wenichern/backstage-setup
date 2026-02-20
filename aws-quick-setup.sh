#!/bin/bash
#
# AWS Integration Quick Setup for Backstage
# This script helps you configure AWS credentials for Backstage
#
# Usage: ./aws-quick-setup.sh
#

set -e

echo "======================================"
echo "AWS + Backstage Integration Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Check prerequisites
echo "Step 1: Checking prerequisites..."
echo ""

if command_exists aws; then
    echo -e "${GREEN}✓${NC} AWS CLI is installed"
    AWS_CLI_VERSION=$(aws --version | cut -d' ' -f1 | cut -d'/' -f2)
    echo "  Version: $AWS_CLI_VERSION"
else
    echo -e "${YELLOW}⚠${NC} AWS CLI not installed"
    echo "  Installing AWS CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            brew install awscli
            echo -e "${GREEN}✓${NC} AWS CLI installed successfully"
        else
            echo -e "${RED}✗${NC} Homebrew not found. Please install AWS CLI manually:"
            echo "  https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
            exit 1
        fi
    else
        echo -e "${RED}✗${NC} Please install AWS CLI manually:"
        echo "  https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
    fi
fi

echo ""

# Step 2: Configure AWS credentials
echo "Step 2: Configuring AWS credentials..."
echo ""

if [ -f ~/.aws/credentials ]; then
    echo -e "${GREEN}✓${NC} AWS credentials file exists"
    echo "  Location: ~/.aws/credentials"
    
    # Test credentials
    if aws sts get-caller-identity >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} AWS credentials are valid"
        ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        USER_ARN=$(aws sts get-caller-identity --query Arn --output text)
        echo "  Account ID: $ACCOUNT_ID"
        echo "  User/Role: $USER_ARN"
    else
        echo -e "${YELLOW}⚠${NC} Credentials file exists but credentials are invalid"
        echo "  Run: aws configure"
    fi
else
    echo -e "${YELLOW}⚠${NC} AWS credentials not configured"
    echo ""
    echo "Please configure AWS CLI now:"
    aws configure
    
    # Verify after configuration
    if aws sts get-caller-identity >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} AWS credentials configured successfully"
        ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        echo "  Account ID: $ACCOUNT_ID"
    else
        echo -e "${RED}✗${NC} Failed to configure AWS credentials"
        exit 1
    fi
fi

echo ""

# Step 3: Set environment variables
echo "Step 3: Setting up environment variables..."
echo ""

# Determine shell config file
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
    SHELL_NAME="zsh"
elif [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
    SHELL_NAME="bash"
else
    SHELL_RC=~/.bash_profile
    SHELL_NAME="bash"
fi

echo "Detected shell: $SHELL_NAME"
echo "Config file: $SHELL_RC"
echo ""

# Get AWS credentials from AWS CLI config
AWS_ACCESS_KEY=$(aws configure get aws_access_key_id 2>/dev/null || echo "")
AWS_SECRET_KEY=$(aws configure get aws_secret_access_key 2>/dev/null || echo "")
AWS_REGION=$(aws configure get region 2>/dev/null || echo "us-east-1")
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "")

# Check if variables already exist in shell config
if grep -q "AWS_ACCESS_KEY_ID" "$SHELL_RC" 2>/dev/null; then
    echo -e "${YELLOW}⚠${NC} AWS environment variables already exist in $SHELL_RC"
    echo "  Skipping..."
else
    echo "Adding AWS environment variables to $SHELL_RC..."
    
    cat >> "$SHELL_RC" << EOF

# ====================================
# AWS Configuration for Backstage
# Added by aws-quick-setup.sh on $(date)
# ====================================
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY"
export AWS_DEFAULT_REGION="$AWS_REGION"
export AWS_ACCOUNT_ID="$AWS_ACCOUNT_ID"
EOF
    
    echo -e "${GREEN}✓${NC} Environment variables added to $SHELL_RC"
fi

echo ""

# Step 4: Create Backstage config snippet
echo "Step 4: Creating Backstage configuration..."
echo ""

CONFIG_FILE="backstage-aws-config-snippet.yaml"

cat > "$CONFIG_FILE" << EOF
# Add this to your Backstage app-config.yaml
# Location: /path/to/backstage/app-config.yaml

aws:
  accounts:
    - accountId: '\${AWS_ACCOUNT_ID}'
      name: 'Primary AWS Account'
      region: '\${AWS_DEFAULT_REGION}'
      accessKeyId: \${AWS_ACCESS_KEY_ID}
      secretAccessKey: \${AWS_SECRET_ACCESS_KEY}

# Proxy configuration for AWS API calls
proxy:
  '/aws-api':
    target: 'https://aws.amazon.com'
    changeOrigin: true
EOF

echo -e "${GREEN}✓${NC} Created configuration file: $CONFIG_FILE"
echo "  Copy the contents to your Backstage app-config.yaml"

echo ""

# Step 5: GitLab CI Variables Instructions
echo "Step 5: GitLab CI Variable Setup"
echo ""
echo "Add these variables to your GitLab project:"
echo "  Settings → CI/CD → Variables"
echo ""
echo "Required variables:"
echo "  AWS_ACCESS_KEY_ID          = $AWS_ACCESS_KEY (Protected, Masked)"
echo "  AWS_SECRET_ACCESS_KEY      = ******** (Protected, Masked)"
echo "  AWS_DEFAULT_REGION         = $AWS_REGION"
echo "  AWS_ACCOUNT_ID             = $AWS_ACCOUNT_ID"
echo ""

# Step 6: Summary
echo ""
echo "======================================"
echo "Setup Complete! ✓"
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Reload your shell configuration:"
echo "   ${GREEN}source $SHELL_RC${NC}"
echo ""
echo "2. Verify AWS credentials:"
echo "   ${GREEN}aws sts get-caller-identity${NC}"
echo ""
echo "3. Add the config from ${GREEN}$CONFIG_FILE${NC} to your Backstage app-config.yaml"
echo ""
echo "4. Configure GitLab CI variables (see Step 5 above)"
echo ""
echo "5. Restart Backstage:"
echo "   ${GREEN}cd /Users/smarticle/backstage && yarn dev${NC}"
echo ""
echo "6. Test your AWS Golden Path template at:"
echo "   ${GREEN}http://localhost:3000/create${NC}"
echo ""
echo "Documentation:"
echo "  • Full guide: AWS-INTEGRATION-GUIDE.md"
echo "  • Config examples: aws-backstage-config.yaml"
echo ""

# Create a test script
echo "Creating test script..."
cat > test-aws-connection.sh << 'EOF'
#!/bin/bash
echo "Testing AWS Connection..."
echo ""
echo "1. Environment Variables:"
echo "   AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:0:10}..."
echo "   AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY:0:10}..."
echo "   AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION"
echo "   AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"
echo ""
echo "2. AWS CLI Test:"
aws sts get-caller-identity
echo ""
echo "3. EC2 Access Test:"
aws ec2 describe-regions --region $AWS_DEFAULT_REGION --output table
echo ""
echo "✓ AWS connection successful!"
EOF

chmod +x test-aws-connection.sh
echo -e "${GREEN}✓${NC} Created test script: test-aws-connection.sh"
echo ""
echo "Run ${GREEN}./test-aws-connection.sh${NC} to verify your AWS connection"
echo ""

#!/bin/bash
#
# Install Working AWS Plugins for Backstage
# These are the actual available packages
#

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================"
echo "Installing AWS Plugins for Backstage"
echo "======================================"
echo ""

# Check if we're in a Backstage directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}Error: Not in a Backstage directory${NC}"
    echo "Please cd to your Backstage installation first"
    echo "Example: cd /Users/smarticle/backstage"
    exit 1
fi

echo -e "${YELLOW}Note: Using Roadie plugins (verified and working)${NC}"
echo ""

# Install Roadie AWS plugins
echo "Installing @roadiehq/backstage-plugin-aws..."
yarn --cwd packages/app add @roadiehq/backstage-plugin-aws

echo ""
echo "Installing @roadiehq/backstage-plugin-aws-lambda..."
yarn --cwd packages/app add @roadiehq/backstage-plugin-aws-lambda

echo ""
echo -e "${GREEN}✓ Packages installed successfully!${NC}"
echo ""

echo "======================================"
echo "Next Steps:"
echo "======================================"
echo ""
echo "1. Add AWS plugin to your App.tsx:"
echo "   File: packages/app/src/App.tsx"
echo ""
cat << 'EOF'
   import { AwsLambdaPage } from '@roadiehq/backstage-plugin-aws-lambda';

   // In your routes:
   <Route path="/aws-lambda" element={<AwsLambdaPage />} />
EOF

echo ""
echo "2. Add to your component catalog-info.yaml:"
echo ""
cat << 'EOF'
   metadata:
     annotations:
       aws.amazon.com/lambda-function-name: my-function
       aws.amazon.com/lambda-region: us-east-1
EOF

echo ""
echo "3. Configure AWS credentials in app-config.yaml:"
echo ""
cat << 'EOF'
   aws:
     accounts:
       - accountId: '${AWS_ACCOUNT_ID}'
         region: 'us-east-1'
         accessKeyId: ${AWS_ACCESS_KEY_ID}
         secretAccessKey: ${AWS_SECRET_ACCESS_KEY}
EOF

echo ""
echo "4. Restart Backstage:"
echo "   yarn dev"
echo ""
echo -e "${GREEN}Done!${NC}"

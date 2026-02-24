# Backstage Integration Quick Reference

## What is Backstage?

**Backstage** = Open-source developer portal from Spotify  
**Purpose**: Centralize service discovery, documentation, and developer workflows

## Local Installation (macOS)

### Prerequisites

Check that you have Node.js and npm installed:
```bash
node --version  # Should be v18, v20, v22, or v24 (v25 has limited compatibility)
npm --version
```

### Installation Steps

1. **Install Yarn** (required by Backstage)
```bash
npm install -g yarn
```

2. **Create Backstage App**
```bash
cd /path/to/your/workspace
echo "backstage" | npx -y @backstage/create-app@latest
```

3. **Install Dependencies**
```bash
cd backstage
yarn install
```

4. **Fix Node.js v25 Compatibility** (if using Node.js v25)

The scaffolder plugin (for creating new projects) is incompatible with Node.js v25. Disable it by editing `packages/backend/src/index.ts`:

```typescript
// Comment out these lines:
// backend.add(import('@backstage/plugin-scaffolder-backend'));
// backend.add(import('@backstage/plugin-scaffolder-backend-module-github'));
// backend.add(
//   import('@backstage/plugin-scaffolder-backend-module-notifications'),
// );

// Also comment out:
// backend.add(
//   import('@backstage/plugin-catalog-backend-module-scaffolder-entity-model'),
// );
```

### Start Backstage

```bash
cd backstage
yarn start
```

This starts:
- **Frontend**: http://localhost:3000 (main GUI)
- **Backend API**: http://localhost:7007 (REST API)

### Stop Backstage

**Option 1: Using Terminal (Recommended)**
- In the terminal running Backstage, press `Ctrl+C`

**Option 2: Kill Processes**
```bash
# Stop all Backstage processes
lsof -ti:3000,7007 | xargs kill -9
```

**Option 3: Kill by Name**
```bash
pkill -f backstage
```

### Verify Backstage Status

```bash
# Check if Backstage is running
lsof -ti:3000,7007 || echo "Backstage is not running"

# Or check if ports are in use
lsof -ti:3000  # Frontend
lsof -ti:7007  # Backend
```

### Access Backstage

✅ **Use the Frontend GUI**: http://localhost:3000

This is your main interface - it handles authentication automatically and displays:
- Service Catalog
- Documentation
- CI/CD status
- Search

❌ **Don't access Backend directly**: http://localhost:7007

The backend API requires authentication. Direct access returns:
```json
{
  "error": {
    "name": "AuthenticationError",
    "message": "Missing credentials"
  },
  "response": {
    "statusCode": 401
  }
}
```

This is expected! The frontend handles authentication for you.

### Verify Installation

```bash
# Check frontend is running
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000
# Should return: 200

# Check backend is running (will return 401, which is normal)
curl http://localhost:7007/api/catalog/entities
```

### Troubleshooting

**Issue**: `isolated-vm` build failures  
**Solution**: Use Node.js v22 or v24, or disable scaffolder plugin (see step 4 above)

**Issue**: Port 3000 or 7007 already in use  
**Solution**: Stop other services using these ports or configure different ports in `app-config.yaml`

**Issue**: Yarn command not found  
**Solution**: Run `npm install -g yarn`

## Cloning to Another Mac

If you've pushed your Backstage installation to GitHub (like https://github.com/wenichern/awsaidevelopertraining/tree/main/backstage), you can easily set it up on another Mac:

### Prerequisites on New Mac
```bash
# Ensure Node.js is installed
node --version  # v18, v20, v22, or v24 recommended
npm --version

# Install Yarn if needed
npm install -g yarn
```

### Clone and Run
```bash
# Clone the repository
git clone https://github.com/wenichern/awsaidevelopertraining.git
cd awsaidevelopertraining/backstage

# Install dependencies
yarn install

# Start Backstage
yarn start
```

### Access
Open http://localhost:3000 in your browser

**Note**: All configuration and fixes (like the scaffolder plugin compatibility fix) are preserved in the git repository, so it should work immediately!

## Quick Command Reference

### Start Backstage
```bash
cd /Users/smarticle/awsaidevelopertraining/backstage
yarn start
```
- Frontend: http://localhost:3000
- Backend: http://localhost:7007

### Stop Backstage
```bash
# Method 1: In running terminal
Ctrl+C

# Method 2: Kill processes
lsof -ti:3000,7007 | xargs kill -9

# Method 3: Kill by name
pkill -f backstage
```

### Check Status
```bash
# Verify if running
lsof -ti:3000,7007 || echo "Backstage is not running"

# Check frontend (port 3000)
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000

# Test if accessible (should return 200)
```

### Restart Backstage
```bash
# Stop it first
lsof -ti:3000,7007 | xargs kill -9

# Then start
cd /Users/smarticle/awsaidevelopertraining/backstage
yarn start
```

## Integration Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                    BACKSTAGE PORTAL                              │
│                   (http://localhost:3000)                        │
│                                                                  │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────────┐│
│  │   SERVICE   │  │   SOFTWARE   │  │      TECH DOCS        ││
│  │   CATALOG   │  │   TEMPLATES  │  │  (MkDocs + GitHub)    ││
│  │             │  │              │  │                        ││
│  │ - Fashion   │  │ - Create new │  │ - Architecture        ││
│  │   Show      │  │   AI service │  │ - API Reference       ││
│  │   Analysis  │  │ - Scaffolding│  │ - Getting Started     ││
│  │ - APIs      │  │ - Best        │  │ - Runbooks            ││
│  │ - Resources │  │   practices  │  │                        ││
│  └─────────────┘  └──────────────┘  └────────────────────────┘│
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │              CI/CD VISUALIZATION                            ││
│  │  • GitHub Actions status                                   ││
│  │  • Recent deployments                                      ││
│  │  • Build history                                           ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │              AWS RESOURCES                                  ││
│  │  • Lambda metrics                                          ││
│  │  • Step Functions status                                   ││
│  │  • S3 bucket info                                          ││
│  └─────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────┘
                             ↕
┌──────────────────────────────────────────────────────────────────┐
│                   GITHUB REPOSITORY                              │
│                                                                  │
│  catalog-info.yaml ← Service metadata                           │
│  mkdocs.yml        ← Documentation config                       │
│  docs/             ← Documentation content                      │
│  .github/workflows/ ← CI/CD pipelines                           │
└──────────────────────────────────────────────────────────────────┘
```

## Quick Integration Steps

### 1. Install Backstage (One-time)

**If you followed the "Local Installation" section above**, your Backstage instance is at:
```
/Users/smarticle/awsaidevelopertraining/backstage/
```

**Start it with:**
```bash
cd /Users/smarticle/awsaidevelopertraining/backstage
yarn start
```

**Or use existing Backstage instance:**
```
URL: http://localhost:3000 or your-org.backstage.io
```

### 2. Add to Your Repository

✅ **Already Created**:
- `catalog-info.yaml` - Service metadata
- `mkdocs.yml` - Documentation configuration
- `docs/` - Documentation files

### 3. Register in Backstage

**Method 1: Manual** (Quick test)
```
1. Open Backstage → Create
2. Click "Register Existing Component"
3. Enter URL: https://github.com/your-org/awsaidevelopertraining/blob/main/catalog-info.yaml
4. Click "Analyze" → "Import"
5. Done! View your service in catalog
```

**Method 2: Automatic** (Production)
```yaml
# Add to backstage app-config.yaml
catalog:
  providers:
    github:
      providerId:
        organization: 'your-org'
        catalogPath: '/catalog-info.yaml'
        filters:
          branch: 'main'
```

### 4. Install Plugins

```bash
cd your-backstage-app

# GitHub Actions
yarn add --cwd packages/app @backstage/plugin-github-actions

# AWS Lambda
yarn add --cwd packages/app @roadiehq/backstage-plugin-aws-lambda

# Tech Docs (usually pre-installed)
yarn add --cwd packages/app @backstage/plugin-techdocs
```

### 5. Configure GitHub Token

```yaml
# backstage/app-config.yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}  # Store in environment variable
```

### 6. Restart Backstage

```bash
cd backstage
yarn start
```

**Note**: Use `yarn start` (not `yarn dev`) for Backstage.

## What You Get

### 🔍 Service Catalog

**Location**: Backstage → Catalog → fashion-show-analysis

**Shows**:
- Service description
- Owner and team
- System dependencies
- API endpoints
- Links to AWS console
- Tags for discovery

**Example View**:
```
┌───────────────────────────────────────────────┐
│ Fashion Show Analysis                         │
│ team-ai-platforms                             │
│                                               │
│ AI-powered fashion trend analysis using       │
│ Amazon Bedrock multimodal FMs                 │
│                                               │
│ Tags: ai, ml, bedrock, fashion                │
│                                               │
│ Links:                                        │
│  🔗 AWS Console                               │
│  🔗 Architecture Docs                         │
│  🔗 GitHub Actions                            │
│                                               │
│ APIs: fashion-analysis-api                    │
│ Dependencies: bedrock, s3, step-functions     │
└───────────────────────────────────────────────┘
```

### 🚀 Software Templates

**Location**: Backstage → Create → AI Analysis Service

**Creates**:
- New GitHub repository
- AWS infrastructure (via Terraform)
- CI/CD pipeline setup
- Documentation structure
- Automatic catalog registration

**Use Case**: Team wants to create similar video analysis service
```
1. Click "Create" in Backstage
2. Select "AI Analysis Service" template
3. Fill in form:
   - Service name
   - Bedrock model
   - AWS region
4. Click "Create"
5. New service deployed in minutes!
```

### 📚 Tech Docs

**Location**: Backstage → Catalog → fashion-show-analysis → Docs tab

**Shows**:
- Architecture diagrams
- Getting started guide
- API reference
- Troubleshooting
- Runbooks

**Auto-updates**: Docs deploy with code changes via CI/CD

### 📊 CI/CD Dashboard

**Location**: Backstage → Catalog → fashion-show-analysis → CI/CD tab

**Shows**:
- ✅ Recent workflow runs
- 🏗️ Build status
- 📈 Success rate
- ⏱️ Deployment times
- 🔄 Re-run failed builds (one-click)

### 🔧 AWS Resources

**Location**: Backstage → Catalog → fashion-show-analysis → AWS tab

**Shows**:
- Lambda function metrics
- Recent invocations
- Error rates
- Duration stats

## Team Benefits

| Before Backstage | With Backstage |
|------------------|----------------|
| Search GitHub for services | Browse unified catalog |
| Ask team for architecture | Read self-service docs |
| Copy-paste code to start | Use software templates |
| Check GitHub for builds | See status in portal |
| Switch between tools | Everything in one place |

**Productivity Gain**: 30-40% reduction in onboarding time

## File Reference

| File | Purpose | Status |
|------|---------|--------|
| `catalog-info.yaml` | Service metadata | ✅ Created |
| `mkdocs.yml` | Docs configuration | ✅ Created |
| `docs/index.md` | Home page | ✅ Created |
| `docs/architecture.md` | Architecture | ✅ Created |
| `docs/getting-started.md` | Getting started | ✅ Created |
| `BACKSTAGE-INTEGRATION.md` | Full guide | ✅ Created |

## Next Actions

### Day 1: Basic Setup
- [ ] Install Backstage (if needed)
- [ ] Register service in catalog
- [ ] Verify it appears in UI

### Week 1: Documentation
- [ ] Build docs: `mkdocs build`
- [ ] Publish to Backstage
- [ ] Train team to update docs

### Week 2: Templates
- [ ] Create AI service template
- [ ] Test template workflow
- [ ] Document for team

### Week 3: Automation
- [ ] Auto-sync catalog entries
- [ ] CI/CD doc publishing
- [ ] Monitoring dashboards

## Common Questions

**Q: Do I need to install Backstage?**  
A: Only if your org doesn't have one. Otherwise, just register your service.

**Q: Why do I get a 401 error when accessing the backend directly?**  
A: The backend API (port 7007) requires authentication. Always use the frontend at http://localhost:3000 instead - it handles auth automatically.

**Q: What's the difference between port 3000 and 7007?**  
A: Port 3000 is the frontend GUI (use this!). Port 7007 is the backend REST API (the frontend calls this automatically).

**Q: How often does Backstage sync with GitHub?**  
A: Every 30 minutes by default (configurable).

**Q: Can I test locally?**  
A: Yes! Run `yarn start` in your Backstage directory (not `yarn dev`).

**Q: What if catalog-info.yaml changes?**  
A: Backstage auto-detects and updates (with auto-discovery) or manual refresh.

**Q: Do I need special permissions?**  
A: Just read access to GitHub repository. Backstage admins handle setup.

**Q: My Backstage won't start with Node.js v25?**  
A: The scaffolder plugin has compatibility issues. Disable it in `packages/backend/src/index.ts` (see Local Installation section above).

## Resources

📖 **Full Guide**: [BACKSTAGE-INTEGRATION.md](../BACKSTAGE-INTEGRATION.md)  
🏠 **Official Docs**: https://backstage.io/docs  
💬 **Community**: https://discord.gg/backstage  
📦 **Plugins**: https://backstage.io/plugins

## Support

- **Backstage Setup**: Ask platform team
- **Service Registration**: See BACKSTAGE-INTEGRATION.md
- **Templates**: See software templates section
- **Docs**: See MkDocs documentation

---

**Quick Win**: Register your service in 5 minutes → immediate visibility!

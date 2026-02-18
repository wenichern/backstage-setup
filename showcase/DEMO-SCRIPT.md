# Backstage Golden Path - Live Demo Script

**Duration:** 10-15 minutes  
**Platform:** Backstage running on Mac at `http://localhost:3000`  
**Goal:** Demonstrate self-service AWS infrastructure provisioning

## 🎯 Demo Overview

**Show how developers can provision AWS infrastructure in 20 minutes instead of 5 days**

### What You'll Demonstrate
- Self-service infrastructure creation through Backstage UI
- GitLab CI/CD automatic pipeline execution
- Terraform Enterprise infrastructure provisioning
- Service catalog integration and visibility

---

## 📋 Pre-Demo Checklist

### Must Have Running
- [ ] Backstage at `http://localhost:3000`
- [ ] Template visible in Create section
- [ ] GitLab account + token configured
- [ ] Terraform Cloud account ready
- [ ] AWS credentials configured

### Preparation
- [ ] Clear browser cache
- [ ] Prepare sample project name: `demo-ecommerce-api`
- [ ] Have two browser windows ready (Backstage + GitLab)
- [ ] Test the flow once beforehand
- [ ] Have backup screenshots ready
- [ ] Close unnecessary applications
- [ ] Set "Do Not Disturb" mode

---

## 🎬 Demo Script

### Part 1: Set the Scene (1 minute)

**The Problem Statement:**

> "Let me show you how we've transformed our infrastructure provisioning. Previously, when a developer needed AWS infrastructure, they would:
> 
> - Day 1: Open a ticket
> - Days 2-3: Back-and-forth on requirements  
> - Day 4: Ops team manually sets up infrastructure
> - Day 5: Ready (if everything went well)
> - **Total: 5 days minimum**
> 
> Not to mention the inconsistencies, security vulnerabilities, and manual errors.
> 
> Now, with our Backstage Golden Path, watch this..."

---

### Part 2: Live Demo (10 minutes)

#### Step 1: Show Backstage Home (1 min)

**Action:**
```
Open browser → http://localhost:3000
```

**What to Show:**
- ✅ Backstage home page
- ✅ Left sidebar navigation: Home, Catalog, APIs, Docs, **Create**
- ✅ Existing services in catalog (if any)

**Script:**
> "This is our Backstage developer portal running here on my Mac. This is where developers discover services, APIs, documentation, and most importantly - create new infrastructure through our Golden Path templates."

**Talking Points:**
- Internal developer platform
- Single pane of glass for all services
- Self-service capabilities

---

#### Step 2: Navigate to Templates (1 min)

**Action:**
```
Click "Create" in left sidebar
```

**What to Show:**
- ✅ Template gallery
- ✅ **"AWS Infrastructure Golden Path"** template card
- ✅ Template description and tags (aws, terraform, gitlab-ci)

**Script:**
> "Here in our template gallery, we have our Golden Path templates. This 'AWS Infrastructure Golden Path' template is what we're showing today. It allows any developer to provision complete AWS infrastructure - VPC, EC2, optional Kubernetes, with Terraform and GitLab CI - all through a simple form. No Terraform knowledge required."

**Talking Points:**
- Multiple templates available
- Each template represents best practices
- Consistent, secure, tested infrastructure patterns

---

#### Step 3: Fill the Form (3 min)

**Action:**
```
Click on "AWS Infrastructure Golden Path" template
```

**What to Fill (Have This Ready):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project Information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project Name: demo-ecommerce-api
Owner: [Your name/team]
Environment: dev
Description: E-commerce API backend infrastructure

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Infrastructure Configuration:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AWS Region: us-east-1
Instance Type: t3.small
VPC CIDR: 10.0.0.0/16
Enable Kubernetes: ☐ (leave unchecked for faster demo)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Application Configuration:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Application Port: 8080
Health Check Path: /health
Docker Image: (leave empty)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GitLab Repository:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GitLab Group: infrastructure
Visibility: private
```

**Script While Filling:**
> "Look how developer-friendly this is. Developers just fill out this form:
> 
> - **Project name** - what they're building
> - **Environment** - dev, staging, or production  
> - **AWS region** - where to deploy
> - **Instance type** - t3.small is perfect for dev
> - **Enable Kubernetes** - optional, I'll skip it for now to keep it simple
> - **Application port** - standard 8080
> 
> Notice there's no Terraform code, no YAML configuration. All the complexity is abstracted away. The platform team has encoded best practices into this template."

**Talking Points:**
- Developer-friendly interface
- No infrastructure expertise required  
- Consistent configurations
- Security baked in

---

#### Step 4: Create & Watch Magic Happen (1 min)

**Action:**
```
Click "Create" button
```

**What to Show:**
- ✅ Progress indicator/loading screen
- ✅ Steps being executed in real-time:
  ```
  ✓ Fetch Base Template
  ✓ Publish to GitLab
  ✓ Register Component in Catalog
  ✓ Create GitLab CI Variables
  ```

**Script:**
> "I'll click Create, and watch what happens. Backstage is now:
> 
> 1. Creating a GitLab repository with all our infrastructure code
> 2. Generating Terraform files for VPC, EC2, security groups
> 3. Creating the GitLab CI pipeline configuration
> 4. Registering this service in our catalog
> 5. Setting up encrypted CI/CD variables
> 
> All automatically, in just seconds."

**Talking Points:**
- Fully automated
- No manual steps
- Secure by default

---

#### Step 5: Show Success Page (1 min)

**What to Show:**
- ✅ Success message: "🎉 Your project has been created!"
- ✅ Three important links:
  - 🔗 GitLab Repository
  - 🔗 GitLab CI Pipeline  
  - 🔗 Open in Catalog

**Script:**
> "Done! In 30 seconds, we've created a complete infrastructure project. Look at what we get:
> 
> - Direct link to the GitLab repository with all the code
> - Link to the CI/CD pipeline that's already running
> - It's already registered in our service catalog for visibility
> 
> Let me show you what was created..."

---

#### Step 6: Show GitLab Repository (2 min)

**Action:**
```
Click "GitLab Repository" link
(Opens gitlab.com/infrastructure/demo-ecommerce-api)
```

**What to Show & Explain:**

```
demo-ecommerce-api/
├── .gitlab-ci.yml              ← "Complete CI/CD pipeline"
├── catalog-info.yaml           ← "Backstage integration"  
├── terraform/
│   ├── main.tf                 ← "Infrastructure as Code"
│   ├── variables.tf
│   └── outputs.tf
└── scripts/
    ├── install-docker.sh       ← "Deployment automation"
    ├── install-kubectl.sh
    ├── install-helm.sh
    └── deploy-app.sh
```

**Script:**
> "Here's the GitLab repository that was automatically generated. Let me walk through what's here:
> 
> **Terraform folder** - Complete infrastructure as code. VPC with subnets, EC2 instances, security groups, networking. Production-ready, best-practice configuration.
> 
> **.gitlab-ci.yml** - The CI/CD pipeline with stages for validation, planning, provisioning, deployment, and verification.
> 
> **Scripts** - Automated scripts to install Docker, Kubernetes tools, and deploy applications on the new infrastructure.
> 
> **catalog-info.yaml** - Integration with Backstage for service discovery.
> 
> All of this generated in seconds. A developer would need hours or days to create this from scratch, and it would likely have inconsistencies."

**Open one file (main.tf):**
```terraform
# Show VPC, subnets, EC2 configuration
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # ...
}
```

**Talking Points:**
- Production-ready code
- Best practices baked in
- Consistent across all projects
- Security groups properly configured

---

#### Step 7: Show GitLab CI Pipeline (2 min)

**Action:**
```
In GitLab: Click "CI/CD" → "Pipelines"
```

**What to Show:**
- ✅ Pipeline already running (or completed)
- ✅ Pipeline stages:
  ```
  [validate] → [plan] → [provision] → [deploy] → [verify]
       ✓           ✓         ⏸️           -          -
  ```

**Click on a completed job (e.g., terraform-plan)**

**Script:**
> "The pipeline started automatically the moment the repository was created. Let's look at the stages:
> 
> **Validate** - Checks Terraform syntax and formatting. Already passed ✓
> 
> **Plan** - Creates the execution plan. Shows exactly what will be created. Let me open this...
> 
> [Open the logs]
> 
> See here - it shows: '15 resources to add, 0 to change, 0 to destroy'
> That's our VPC, subnets, internet gateway, route tables, security groups, EC2 instance...
> 
> **Provision** - This has a manual approval gate. This is important for governance. Even though it's self-service, we have controls. For production, we'd require approval from platform team or tech lead.
> 
> **Deploy** - After infrastructure is created, this stage SSHs to the new EC2 instances and runs our installation scripts - Docker, kubectl, Helm.
> 
> **Verify** - Runs health checks to ensure everything is working."

**Talking Points:**
- Automated but controlled
- Approval gates for safety
- Full visibility into what's happening
- Complete audit trail

---

#### Step 8: Show Backstage Catalog (1 min)

**Action:**
```
Go back to Backstage → Click "Catalog" in sidebar
Search for: "demo-ecommerce-api"
Click on the component
```

**What to Show:**
- ✅ Component card with metadata
- ✅ **Overview tab:**
  - Description
  - Owner
  - Environment (dev)
  - Links to GitLab, AWS Console
- ✅ **CI/CD tab:** (if plugin installed) Pipeline status
- ✅ **API tab:** (if APIs defined)

**Script:**
> "Back in Backstage, our new infrastructure project is now part of the service catalog. This creates organizational visibility.
> 
> - Engineering managers can see all active projects
> - Security team can audit configurations
> - Developers can find related services and dependencies
> - Everything has an owner - no orphaned resources
> 
> We can also set up cost tracking, compliance checks, and documentation right here."

**Talking Points:**
- Central visibility
- Ownership and accountability  
- Service discovery
- Documentation hub

---

### Part 3: The Big Picture (1 min)

**Show the Timeline:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BEFORE (Manual Process):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Day 1:  Developer opens ticket
Day 2-3: Back and forth on requirements
Day 4:  Ops team provisions infrastructure
Day 5:  Ready (maybe)

⏱️  Total: 5+ days
❌  Issues: Manual errors, inconsistency, no visibility

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AFTER (Backstage Golden Path):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Minute 1:   Developer fills form
Minute 2-20: Automatic provisioning
Minute 20:  Infrastructure ready

⏱️  Total: 20 minutes
✅  Benefits: Consistent, secure, tracked, self-service
```

**Script:**
> "Let's look at what we accomplished:
> 
> We went from **5 days to 20 minutes**. That's a **95% reduction** in provisioning time.
> 
> But it's not just about speed. It's about:
> - **Consistency** - Every project uses our tested patterns
> - **Security** - Best practices baked in, not optional
> - **Visibility** - Everything tracked in the service catalog
> - **Developer Experience** - Developers stay in flow, don't wait for tickets
> - **Platform Team** - Can focus on improving platforms, not repetitive provisioning
> 
> This is Platform Engineering in action."

---

## 🎯 Key Messages to Drive Home

### 1. Developer Empowerment
> "Developers are empowered, not blocked. They can move fast while we maintain guard rails."

### 2. Speed Without Chaos  
> "20 minutes instead of 5 days, but with controls, security, and consistency."

### 3. Golden Path
> "We make the right way the easy way. Developers naturally follow best practices because it's the path of least resistance."

### 4. Platform as Product
> "This isn't just automation. It's a platform product we built for our internal customers - the developers."

### 5. Business Impact
> "Faster time to market, reduced operational burden, improved security posture, and happier developers."

---

## ✅ Demo Success Criteria

You nailed the demo if attendees:
- ✅ Understand the problem (slow, manual, error-prone)
- ✅ See the solution (fast, automated, consistent)
- ✅ Believe it's achievable (not magic, just good engineering)
- ✅ Want to adopt it (excited about possibilities)
- ✅ Ask thoughtful questions (engaged and thinking)

---

## 🚨 Troubleshooting During Demo

### If Backstage won't load
- Have backup screenshots ready
- Walk through the screenshots as if live
- "Let me show you what this looks like..."

### If GitLab is slow
- Have a pre-created example repository ready
- "While that's loading, let me show you a different project..."

### If pipeline fails
- This can actually be good! Shows transparency
- "Look - we have full visibility when things fail"
- "This is why we have manual approval gates"

### If you forget what to say
- Just narrate what you're doing: "Now I'm filling in the project name..."
- Let the UI speak for itself
- Silence is okay, shows you're comfortable

---

**Remember:** You're not just demoing a tool. You're showing a transformation in how infrastructure is provisioned. Make it about the impact, not the technology.

**Good luck! 🚀**

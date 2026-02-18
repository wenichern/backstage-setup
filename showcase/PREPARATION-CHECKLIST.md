# Backstage Demo - Preparation Checklist

Use this checklist 30 minutes before your demo to ensure everything is ready.

## ⏰ 30 Minutes Before Demo

### 1. System Check

- [ ] **Mac is charged** or plugged in
- [ ] **WiFi/Internet** is stable and fast
- [ ] **Screen sharing** software tested (Zoom/Teams/etc)
- [ ] **Display settings** optimized (1920x1080 recommended)
- [ ] **Font size** increased for visibility
- [ ] **Notifications** turned off (Do Not Disturb mode)
- [ ] **Close unnecessary apps** (Slack, email, etc)

### 2. Backstage Setup

- [ ] **Backstage is running**
  ```bash
  cd /path/to/backstage
  yarn dev
  ```
- [ ] **Test access:** Open `http://localhost:3000`
- [ ] **Template is visible** in Create section
- [ ] **Clear any test projects** from previous runs

### 3. Environment Variables

Check all required environment variables are set:

```bash
# Run these checks
echo $GITLAB_TOKEN        # Should show: glpat-xxxxx
echo $TFE_TOKEN          # Should show: your-token
echo $TFE_ORGANIZATION   # Should show: your-org-name
```

- [ ] **GITLAB_TOKEN** is set and valid
- [ ] **TFE_TOKEN** is set and valid
- [ ] **TFE_ORGANIZATION** is set correctly
- [ ] **AWS_ACCESS_KEY_ID** is set (if needed)
- [ ] **AWS_SECRET_ACCESS_KEY** is set (if needed)

### 4. GitLab Access

- [ ] **GitLab is accessible:** https://gitlab.com
- [ ] **You're logged in** to GitLab
- [ ] **Token hasn't expired**
- [ ] **Test token:** 
  ```bash
  curl -H "PRIVATE-TOKEN: $GITLAB_TOKEN" https://gitlab.com/api/v4/user
  ```
- [ ] **Clear any old test repos** (optional)

### 5. Terraform Cloud

- [ ] **Terraform Cloud is accessible:** https://app.terraform.io
- [ ] **You're logged into** your organization
- [ ] **Token is valid**
- [ ] **Workspace quota** available (not at limit)

### 6. AWS Console (Optional but Recommended)

- [ ] **AWS Console** open in a tab: https://console.aws.amazon.com
- [ ] **Navigate to EC2** (us-east-1 or your demo region)
- [ ] **Note current instance count** (you'll see new ones appear)

### 7. Browser Setup

- [ ] **Chrome/Firefox** updated to latest version
- [ ] **Two browser windows** ready:
  - Window 1: Backstage (localhost:3000)
  - Window 2: GitLab (gitlab.com)
- [ ] **Zoom level** set to 100% or 110% for readability
- [ ] **Bookmarks bar hidden** (cleaner look)
- [ ] **Extensions disabled** (ad blockers can cause issues)
- [ ] **Clear browser cache**

### 8. Demo Data Prepared

Have this written down or in a text file:

```
Project Name: demo-ecommerce-api
Owner: [Your name]
Environment: dev
Description: E-commerce API backend infrastructure
AWS Region: us-east-1
Instance Type: t3.small
VPC CIDR: 10.0.0.0/16
Enable Kubernetes: NO (unchecked)
Application Port: 8080
Health Check Path: /health
Docker Image: (leave empty)
GitLab Group: infrastructure
Visibility: private
```

- [ ] **Demo data** copied and ready to paste

### 9. Backup Materials

- [ ] **Screenshots** of each step saved
- [ ] **Demo script** printed or on second screen
- [ ] **FAQ document** ready
- [ ] **Example repository** URL ready (if demo fails)
- [ ] **Video recording** of successful demo (backup)

### 10. Presentation Setup

- [ ] **Slides** ready (if any)
- [ ] **Screen sharing** tested
- [ ] **Audio** tested
- [ ] **Camera** positioned (if using video)
- [ ] **Lighting** is good
- [ ] **Background** is professional

## 🔄 5 Minutes Before Demo

### Quick Verification Run

1. **Open Backstage**
   ```
   ✓ Loads without errors
   ✓ Template visible in Create
   ```

2. **Check GitLab**
   ```
   ✓ Can access gitlab.com
   ✓ Logged in
   ```

3. **Deep breath** 🧘‍♀️

4. **Review key talking points:**
   - Problem: 5 days manual provisioning
   - Solution: 20 minutes self-service
   - Value: Consistency, security, speed

## ⚠️ Common Issues & Quick Fixes

### Issue: Backstage won't start

**Fix:**
```bash
# Kill any existing processes
pkill -f "node.*backstage"

# Restart
cd /path/to/backstage
yarn dev
```

**Backup:** Use screenshots or video

---

### Issue: Template not showing

**Fix:**
```bash
# Check template file exists
ls -la /path/to/backstage/templates/aws-infrastructure-golden-path/template.yaml

# Force catalog refresh
curl -X POST http://localhost:3000/api/catalog/refresh

# Restart Backstage
```

**Backup:** Show the template.yaml file directly

---

### Issue: GitLab token expired

**Fix:**
```bash
# Generate new token at:
https://gitlab.com/-/profile/personal_access_tokens

# Set new token
export GITLAB_TOKEN="glpat-new-token"

# Restart Backstage
```

---

### Issue: Environment variables not set

**Fix:**
```bash
# Quick set
export GITLAB_TOKEN="glpat-xxxxx"
export TFE_TOKEN="your-token"
export TFE_ORGANIZATION="your-org"

# Or source from file
source ~/.zshrc
```

---

### Issue: Internet/WiFi slow or disconnected

**Backup:**
- Switch to phone hotspot
- Use pre-recorded video
- Walk through screenshots
- Reschedule if critical

---

### Issue: Screen sharing not working

**Fix:**
- Grant screen recording permissions: System Preferences → Security & Privacy → Screen Recording
- Restart Zoom/Teams
- Use different browser

**Backup:**
- Share specific window instead of entire screen
- Have co-presenter share their screen

---

## 📝 During Demo - Quick Reference Card

Keep this visible:

```
┌──────────────────────────────────────────┐
│  DEMO FLOW QUICK REFERENCE               │
├──────────────────────────────────────────┤
│  1. Show problem (5 days)                │
│  2. Open Backstage                       │
│  3. Click Create                         │
│  4. Fill form (use prepared data)        │
│  5. Click Create                         │
│  6. Show GitLab repo                     │
│  7. Show pipeline                        │
│  8. Show Backstage catalog               │
│  9. Show results (20 minutes)            │
│  10. Q&A                                 │
└──────────────────────────────────────────┘
```

## 🎬 After Demo

- [ ] **Stop screen sharing** before closing browsers
- [ ] **Save any screenshots** of successful flow
- [ ] **Note any questions** you couldn't answer
- [ ] **Clean up test resources** (optional)
- [ ] **Send follow-up email** with links and docs
- [ ] **Update this checklist** with lessons learned

## 💡 Pro Tips

### For Smooth Demo

1. **Practice 3 times** before the real demo
2. **Time yourself** - aim for 10-12 minutes, leaving 3-5 for Q&A
3. **Have water** nearby (talking is thirsty work)
4. **Stand up** while presenting (more energy)
5. **Smile** - enthusiasm is contagious

### For Virtual Demos

1. **Mute yourself** when not talking (reduces background noise)
2. **Look at camera** when talking (not screen)
3. **Use second monitor** for notes/chat
4. **Have phone ready** as backup if computer fails
5. **Join 5 minutes early** to test everything

### For In-Person Demos

1. **Bring charging cable**
2. **Test HDMI/projector connection** beforehand
3. **Have backup laptop** (if high-stakes demo)
4. **Print backup slides**
5. **Face the audience** not the screen

## ✅ Final Check

**You're ready to go if:**

- ✅ Backstage is running and accessible
- ✅ Template is visible
- ✅ GitLab and Terraform Cloud are accessible
- ✅ Demo data is prepared
- ✅ Backup materials ready
- ✅ You've practiced the flow
- ✅ You're calm and confident

## 🚀 Let's Do This!

Remember:
- You know this material inside and out
- The demo shows real value
- It's okay if something goes wrong - that shows resilience
- Focus on the story, not perfection
- Enthusiasm beats perfection

**You've got this! 💪**

---

## 📞 Emergency Contacts

Have these handy (just in case):

- Platform team lead: _____________
- GitLab admin: _____________
- AWS admin: _____________
- Backstage expert: _____________

---

**Last updated:** February 18, 2026

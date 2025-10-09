---
title: Auto - Ansible Automation Wingman
description: "Automating the boring stuff since... well, today!"
navigation:
  icon: i-lucide-bot
---

> *"Automating the boring stuff since... well, today!"* - Semaphore UI

## What's This All About?

This is your command center for Ansible automation! Semaphore UI is like having a beautiful, web-based control panel for all your infrastructure automation tasks. No more SSH-ing into servers at 2 AM - just click a button and watch the magic happen!

## The Dream Team

### :icon{name="lucide:target"} Semaphore UI

**Container**: `auto_app`  
**Image**: `semaphoreui/semaphore:v2.16.18`  
**Port**: 3000  
**Home**: http://localhost:3000 (Traefik labels commented out - local access only for now!)

Semaphore is the fancy GUI wrapper around Ansible that makes you look like a DevOps wizard:
- :icon{name="lucide:clipboard"} **Project Management**: Organize your playbooks like a boss
- :icon{name="lucide:gamepad-2"} **Job Execution**: Run Ansible tasks with a click
- :icon{name="lucide:bar-chart"} **Task Monitoring**: Watch your automation in real-time
- :icon{name="lucide:mail"} **Email Alerts**: Get notified when things succeed (or explode)
- :icon{name="lucide:lock-keyhole"} **User Management**: Team collaboration without the chaos
- :icon{name="lucide:scroll"} **Audit Logs**: Know who deployed what and when

### 🏃‍♂️ Semaphore Runner

**Container**: `auto_runner`  
**Image**: `public.ecr.aws/semaphore/pro/runner:v2.16.18`

This is the actual workhorse that executes your Ansible tasks. The UI is the pretty face, but the runner does the heavy lifting!

## How They Work Together

```
You → Semaphore UI → Queue Task → Runner Picks It Up → Ansible Magic Happens
                       ↓
                  PostgreSQL
                 (Stores Everything)
```

## Configuration Breakdown

### Database Connection
All your projects, tasks, and secrets (encrypted!) live in PostgreSQL:
```
Database: semaphore
Host: Shared data stack
```

### Admin Credentials
**Username**: `admin`  
**Password**: `changeme` (please actually change this one!)  
**Email**: Set in root `.env` file

### Email Notifications
Configured to send alerts via SMTP when tasks complete. Perfect for those "deploy and go to lunch" moments!

## Environment Variables Explained

| Variable | What It Does | Why You Care |
|----------|-------------|--------------|
| `SEMAPHORE_DB_*` | PostgreSQL connection | :icon{name="simple-icons:postgresql"} Where memories live |
| `SEMAPHORE_ADMIN` | Admin username | 👑 The supreme commander |
| `SEMAPHORE_EMAIL_*` | SMTP settings | :icon{name="lucide:mail"} "Your deploy finished!" |
| `SEMAPHORE_RUNNER_REGISTRATION_TOKEN` | Runner auth token | :icon{name="lucide:ticket"} Runner's VIP pass |

## Ports & Networking

- **UI Port**: 3000 (exposed directly - Traefik labels commented out)
- **Network**: `kompose` (playing nice with other containers)
- **Runner**: Internal only, talks to UI via network

## Persistent Storage

Three volumes keep your data safe:
- `semaphore_data`: Your precious projects and keys
- `semaphore_config`: Configuration files
- `semaphore_tmp`: Temporary execution files

## Health Checks

### Semaphore API Ping
Every 30 seconds: "Hey, you still awake?"
```bash
curl -f http://localhost:3000/api/ping
```

### Runner
Checks if its private key exists (without it, it can't work)

## Getting Started

### First Time Setup

1. **Start the stack**:
   ```bash
   docker compose up -d
   ```

2. **Access the UI**:
   ```
   URL: http://localhost:3000
   Username: admin
   Password: changeme (then change it!)
   ```

3. **Create your first project**:
   - Click "New Project"
   - Add your Git repository
   - Configure SSH keys if needed
   - Add inventory (your servers)
   - Create your first template (playbook reference)

4. **Run a task**:
   - Select your template
   - Hit "Run"
   - Watch the logs in real-time
   - Feel like a hacker in a movie 😎

### Adding SSH Keys

For connecting to your servers:
1. Go to Key Store
2. Add new Key
3. Type: SSH
4. Paste your private key
5. Save and use in your projects

## Common Use Cases

### Server Provisioning
```yaml
# playbook.yml
- hosts: webservers
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

### Configuration Management
Keep your servers in sync with desired state. Change config → Run playbook → All servers updated!

### Deployment Automation
Push code to production without the sweaty palms:
1. Pull latest code
2. Run database migrations
3. Restart services
4. Clear caches
5. Sleep peacefully

## Troubleshooting

**Q: Runner not connecting?**  
A: Check the `JWT_TOKEN` matches in both UI settings and runner env

**Q: Tasks failing immediately?**  
A: Verify SSH keys are correctly configured and servers are reachable

**Q: Email notifications not working?**  
A: Double-check SMTP settings in `.env` file

**Q: Can't log in?**  
A: Default is `admin`/`changeme` - check if you changed it and forgot!

## Security Tips :icon{name="lucide:lock"}

- :icon{name="lucide:key"} Store SSH keys properly (private keys in Semaphore, never in repos)
- :icon{name="lucide:lock-keyhole"} Use Ansible Vault for sensitive variables
- :icon{name="lucide:users"} Create individual user accounts (don't share the admin account)
- :icon{name="lucide:file-text"} Review audit logs regularly
- :icon{name="lucide:ban"} Don't store passwords in plain text in playbooks

## Pro Tips :icon{name="lucide:lightbulb"}

1. **Use Surveys**: Create web forms for playbook variables (great for non-technical users)
2. **Schedule Tasks**: Set up cron-like scheduling for regular maintenance
3. **Task Notifications**: Enable Slack/Discord webhooks for team notifications
4. **Parallel Execution**: Run tasks on multiple servers simultaneously
5. **Dry Run Mode**: Test playbooks with `--check` flag before real execution

## Integration Ideas

- **CI/CD**: Trigger Semaphore tasks from GitHub Actions or GitLab CI
- **Monitoring**: Deploy monitoring agents to all servers
- **Backup**: Scheduled backup automation
- **Security**: Regular security updates across infrastructure
- **Scaling**: Auto-provision new servers when needed

## Why Semaphore is Awesome

- :icon{name="lucide:sparkles"} Makes Ansible actually fun to use
- :icon{name="lucide:palette"} Beautiful, modern interface
- :icon{name="lucide:refresh-cw"} Task history and versioning
- 👁️ Real-time execution logs
- :icon{name="lucide:target"} RBAC (Role-Based Access Control)
- :icon{name="lucide:smile"} Open source and free

## Resources

- [Semaphore Documentation](https://docs.ansible-semaphore.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Example Playbooks](https://github.com/ansible/ansible-examples)

---

*"Automation is not about replacing humans, it's about freeing them to do more interesting things. Like browsing memes while your servers configure themselves."* :icon{name="lucide:bot"}:icon{name="lucide:sparkles"}

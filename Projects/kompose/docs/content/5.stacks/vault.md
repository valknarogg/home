---
title: Vault - Password Fort Knox
description: "One password to rule them all!"
navigation:
  icon: i-lucide-lock-keyhole
---

> *"One password to rule them all!"* - Vaultwarden

## What's This All About?

Vaultwarden is your self-hosted password manager - a lightweight, Rust-powered alternative to Bitwarden. It's like having a super-secure vault in your pocket, accessible from anywhere, that remembers all your passwords so you don't have to! No more "password123" or writing passwords on sticky notes. :icon{name="lucide:lock"}

## The Security Guardian

### :icon{name="lucide:shield"} Vaultwarden

**Container**: `vault_app`  
**Image**: `vaultwarden/server:latest`  
**Port**: 80 (internal)  
**Home**: https://vault.pivoine.art

Vaultwarden is your digital security blanket:
- :icon{name="lucide:lock-keyhole"} **Password Vault**: Store unlimited passwords
- 🗂️ **Secure Notes**: Credit cards, identities, documents
- :icon{name="lucide:refresh-cw"} **Sync Everywhere**: Desktop, mobile, browser extensions
- :icon{name="lucide:users"} **Sharing**: Securely share with family/team
- :icon{name="lucide:key"} **2FA Support**: TOTP, YubiKey, Duo
- :icon{name="lucide:phone"} **Mobile Apps**: iOS & Android (official Bitwarden apps)
- :icon{name="lucide:globe"} **Browser Extensions**: Chrome, Firefox, Safari, Edge
- :icon{name="lucide:dollar-sign"} **Free**: All premium features, no limits
- :icon{name="simple-icons:rust"} **Rust-Powered**: Secure, fast, resource-efficient

## Why Vaultwarden vs Bitwarden Official?

| Feature | Vaultwarden | Bitwarden Official |
|---------|-------------|-------------------|
| Resource Usage | 🟢 Tiny | 🟡 Heavy (needs MSSQL) |
| Setup | 🟢 Simple | 🟡 Complex |
| Premium Features | 🟢 All free | :icon{name="lucide:dollar-sign"} Paid |
| Compatibility | ✅ 100% | ✅ 100% |
| Updates | 🟢 Community | 🟢 Official |

Both use the same client apps - just different servers!

## Features That Matter 🌟

### Password Management
- :icon{name="lucide:lock-keyhole"} **Unlimited Passwords**: No caps, no limits
- :icon{name="lucide:search"} **Search**: Find credentials instantly
- :icon{name="lucide:folder"} **Folders**: Organize by category
- :icon{name="lucide:tag"} **Tags**: Multiple ways to organize
- ⭐ **Favorites**: Quick access to common items
- :icon{name="lucide:file-text"} **Notes**: Attach notes to any item

### Secure Storage Types
- :icon{name="lucide:key"} **Login**: Username + password combos
- 💳 **Card**: Credit/debit card info
- 🆔 **Identity**: Personal info, addresses
- :icon{name="lucide:file"} **Secure Note**: Encrypted text

### Security Features
- :icon{name="lucide:lock"} **End-to-End Encryption**: Zero-knowledge architecture
- :icon{name="lucide:lock-keyhole"} **Master Password**: Only you know it
- :icon{name="lucide:phone"} **Two-Factor Auth**: Extra security layer
- :icon{name="lucide:refresh-cw"} **Password Generator**: Strong random passwords
- :icon{name="lucide:alert-triangle"} **Security Reports**: Weak, reused, compromised passwords
- :icon{name="lucide:bar-chart"} **Vault Health**: Check security score

### Sharing & Organization
- :icon{name="lucide:users"} **Organizations**: Team password sharing
- :icon{name="lucide:folder"} **Collections**: Group shared passwords
- :icon{name="lucide:lock-keyhole"} **Granular Permissions**: Control who sees what
- :icon{name="lucide:mail"} **Emergency Access**: Trusted contacts can request access

## Configuration Breakdown

### Data Persistence
```yaml
volumes:
  - ./bitwarden:/data:rw
```
All your encrypted data lives here. **PROTECT THIS FOLDER!**

### Admin Token
```bash
JWT_TOKEN=your-admin-token-here
```
Required to access admin panel. Generate with:
```bash
openssl rand -base64 32
```

### WebSocket Support
```bash
WEBSOCKET_ENABLED=true
```
Enables real-time sync across devices!

### SMTP Configuration
Email for account verification and password hints:
```bash
SMTP_HOST=smtp.yourprovider.com
SMTP_PORT=587
SMTP_USERNAME=your@email.com
SMTP_PASSWORD=your-password
SMTP_FROM=vault@yourdomain.com
```

### Signup Control
```bash
SIGNUPS_ALLOWED=false
```
Disable public signups after creating your account!

## First Time Setup :icon{name="lucide:rocket"}

### 1. Start the Stack
```bash
docker compose up -d
```

### 2. Create Your Account
```
URL: https://vault.pivoine.art
Click: "Create Account"
Email: your@email.com
Master Password: Something STRONG!
```

**:icon{name="lucide:alert-triangle"} MASTER PASSWORD WARNING**:
- Only you know it
- Cannot be recovered if lost
- Write it down somewhere safe
- Use a long passphrase (4+ words)

### 3. IMMEDIATELY Disable Signups
```bash
# Edit .env
SIGNUPS_ALLOWED=false

# Restart
docker compose restart
```

### 4. Set Up 2FA
1. Settings → Security → Two-step Login
2. Choose method (Authenticator app recommended)
3. Scan QR code with app (Google Authenticator, Authy, etc.)
4. Save recovery codes somewhere safe!

### 5. Install Browser Extension
- [Chrome/Edge](https://chrome.google.com/webstore/detail/bitwarden/nngceckbapebfimnlniiiahkandclblb)
- [Firefox](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/)
- [Safari](https://apps.apple.com/app/bitwarden/id1352778147)

### 6. Install Mobile App
- [iOS](https://apps.apple.com/app/bitwarden-password-manager/id1137397744)
- [Android](https://play.google.com/store/apps/details?id=com.x8bit.bitwarden)

### 7. Configure Apps
1. Open app/extension
2. Settings → Change server
3. Enter: `https://vault.pivoine.art`
4. Login with your credentials

## Using Your Vault :icon{name="lucide:key"}

### Adding Passwords

**Via Browser Extension**:
1. Visit website and login
2. Extension detects login form
3. Click "Save" when prompted
4. Done! :icon{name="lucide:party-popper"}

**Manually**:
1. Click "+" in vault
2. Choose "Login"
3. Fill in:
   - Name
   - Username
   - Password (or generate)
   - URL
4. Save

### Auto-Fill Passwords
1. Navigate to website
2. Click extension icon
3. Select login
4. Credentials auto-filled!

Or use keyboard shortcut: `Ctrl+Shift+L`

### Generate Strong Passwords
1. Click password field
2. Click generator icon
3. Choose options:
   - Length (12-128 characters)
   - Include uppercase
   - Include numbers
   - Include symbols
4. Use generated password

### Search Your Vault
- Search bar finds items instantly
- Search by name, URL, username, or notes
- Filter by type, folder, or favorites

## Admin Panel 🎛️

Access at: `https://vault.pivoine.art/admin`

**Admin Token Required** (from .env)

### Admin Features
- :icon{name="lucide:users"} View all users
- :icon{name="lucide:lock-keyhole"} Disable/delete users
- :icon{name="lucide:mail"} Resend invitations
- 🗑️ Delete accounts
- :icon{name="lucide:bar-chart"} View diagnostics
- ⚙️ Configure settings

### Useful Admin Tasks

**Disable a User**:
```
Admin Panel → Users → Find user → Disable
```

**View Diagnostics**:
```
Admin Panel → Diagnostics
```
Shows config, health checks, versions

## Sharing with Organizations :icon{name="lucide:users"}

### Create Organization
1. New → Organization
2. Name it (e.g., "Family Passwords")
3. Choose billing (always free on Vaultwarden!)
4. Create

### Invite Members
1. Organization → Manage → People
2. Invite user (by email)
3. They receive invitation email
4. Accept and join

### Share Passwords
1. Create collection (e.g., "Netflix")
2. Add items to collection
3. Set permissions per user
4. Members can access shared passwords

## Security Best Practices :icon{name="lucide:shield"}

### Master Password
- ✅ Use a passphrase: `correct-horse-battery-staple`
- ✅ At least 14+ characters
- ✅ Unique (not used elsewhere)
- ✅ Write it down physically
- ❌ Don't store digitally
- ❌ Don't share it

### Two-Factor Authentication
- ✅ Enable 2FA immediately
- ✅ Save recovery codes
- ✅ Use authenticator app (not SMS)
- ✅ Consider hardware key (YubiKey)

### Vault Hygiene
- :icon{name="lucide:refresh-cw"} Regular security reports
- :icon{name="lucide:search"} Update weak passwords
- 🗑️ Remove old accounts
- :icon{name="lucide:mail"} Use unique emails when possible
- :icon{name="lucide:lock-keyhole"} Never reuse passwords

### Backup Strategy
```bash
# Backup vault data
tar -czf vault-backup-$(date +%Y%m%d).tar.gz ./bitwarden/

# Store backup securely:
# - Encrypted external drive
# - Encrypted cloud storage
# - Offsite location
```

## Emergency Access 🆘

### Setting Up Emergency Access
1. Settings → Emergency Access
2. Add trusted contact (email)
3. Set wait time (e.g., 7 days)
4. They receive invitation

### How It Works
1. Trusted contact requests access
2. Wait time begins (you get notification)
3. After wait time, access granted
4. You can reject anytime during wait

**Use Cases**:
- Family member needs access
- You're incapacitated
- Account recovery

## Ports & Networking

- **Internal Port**: 80
- **External Access**: Via Traefik at https://vault.pivoine.art
- **Network**: `kompose` (Traefik routing)
- **WebSocket**: Enabled for real-time sync

## Data & Volumes

### Bitwarden Data Directory
```
./bitwarden/
├── attachments/     # File attachments
├── sends/          # Send feature data
├── db.sqlite3      # Main database
├── db.sqlite3-shm  # SQLite shared memory
├── db.sqlite3-wal  # Write-ahead log
├── icon_cache/     # Website favicons
└── rsa_key.*       # Server keys
```

**:icon{name="lucide:siren"} CRITICAL**: Backup this entire directory regularly!

## Performance & Limits

### Resource Usage
- Memory: ~10-20 MB (yes, megabytes!)
- CPU: Minimal
- Disk: ~50MB + your data

### Capacity
- Users: Unlimited
- Items per user: Unlimited
- Organizations: Unlimited
- File attachments: 1GB per user (configurable)

## Troubleshooting :icon{name="lucide:wrench"}

**Q: Can't log in?**  
A: Check master password, verify server URL in apps

**Q: Forgot master password?**  
A: Unfortunately, it cannot be recovered. This is by design for security.

**Q: 2FA locked out?**  
A: Use recovery codes you saved during setup

**Q: Items not syncing?**  
A: Check WebSocket is enabled, verify network connection

**Q: Can't access admin panel?**  
A: Verify admin token in .env matches your token

**Q: Email not sending?**  
A: Check SMTP settings, test email server connection

## Import from Other Managers

Vaultwarden supports imports from:
- LastPass
- 1Password
- Dashlane
- KeePass
- Chrome
- Firefox
- And many more!

**Import Process**:
1. Export from old manager (usually CSV)
2. Vault → Tools → Import Data
3. Select format
4. Upload file
5. Import!

## Browser Extension Tips :icon{name="lucide:lightbulb"}

### Keyboard Shortcuts
- `Ctrl+Shift+L`: Auto-fill last used login
- `Ctrl+Shift+9`: Generate password
- `Ctrl+Shift+Y`: Open vault

### Context Menus
Right-click in password fields:
- Auto-fill from Bitwarden
- Generate password
- Copy to clipboard

### Custom Fields
Add extra fields to logins:
- Security questions
- PIN codes
- Account numbers
- Anything you need!

## Advanced Features

### Send (Encrypted Sharing)
Share text or files securely:
1. Create Send
2. Set expiration
3. Optional password
4. Share link
5. Auto-deletes after use/time

### Password Health Reports
Check vault health:
- Weak passwords
- Reused passwords  
- Exposed passwords (via haveibeenpwned)
- Unsecured websites (HTTP)

### Collections
Organize shared items:
- Team credentials
- Client access
- Project resources
- Department logins

## Why Self-Host Your Passwords?

- :icon{name="lucide:lock"} **Full Control**: Your data, your server
- 🕵️ **Privacy**: No third-party access
- :icon{name="lucide:dollar-sign"} **Cost**: Free premium features
- :icon{name="lucide:rocket"} **Performance**: Local network speed
- :icon{name="lucide:shield"} **Security**: You control the security
- 🌍 **Independence**: Not dependent on cloud service
- :icon{name="lucide:bar-chart"} **Transparency**: Open source, auditable

## Resources

- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/)
- [Password Security Guide](https://www.nist.gov/blogs/taking-measure/easy-ways-build-better-p5w0rd)

---

*"The best password is the one you don't have to remember because it's safely stored in your vault."* - Password Wisdom :icon{name="lucide:lock-keyhole"}:icon{name="lucide:sparkles"}

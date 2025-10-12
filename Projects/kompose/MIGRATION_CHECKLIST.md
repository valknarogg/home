# ✅ Kompose Environment Migration Checklist

Use this checklist to track your migration progress.

## Pre-Migration

- [ ] Read `MIGRATION_SUMMARY.md`
- [ ] Read `ENV_QUICK_REFERENCE.md`
- [ ] Review `.env.new` file
- [ ] Understand the new structure
- [ ] Backup current setup (optional, script does this automatically)

## Migration Steps

### 1. Review New Configuration
- [ ] Open and review `.env.new`
- [ ] Compare with current `.env`
- [ ] Understand stack scoping (`CORE_`, `AUTH_`, etc.)
- [ ] Check if any custom variables need to be added

### 2. Prepare Secrets
- [ ] Review `secrets.env.template`
- [ ] Either:
  - [ ] Copy and edit: `cp secrets.env.template secrets.env`
  - [ ] Or generate new: `./kompose.sh secrets generate > temp-secrets.txt`
- [ ] Edit `secrets.env` with actual values
- [ ] Set proper permissions: `chmod 600 secrets.env`
- [ ] Verify not tracked by git: `git status | grep secrets.env` (should be empty)

### 3. Run Migration Script
- [ ] Make script executable: `chmod +x migrate-to-centralized-env.sh`
- [ ] Run migration: `./migrate-to-centralized-env.sh`
- [ ] Verify backups created in `backups/env-migration-*/`
- [ ] Confirm old `.env` files removed from stacks
- [ ] Check `.gitignore` updated with `.env.generated`

### 4. Test Core Stack (Foundation)
- [ ] Validate: `./kompose.sh env validate core`
- [ ] View env: `./kompose.sh env show core`
- [ ] Start: `./kompose.sh up core`
- [ ] Check status: `./kompose.sh status core`
- [ ] Verify databases created: `docker exec core-postgres psql -U valknar -l`
- [ ] Check Redis: `docker exec core-redis redis-cli -a <password> PING`
- [ ] Test MQTT: `mosquitto_pub -h localhost -t test -m hello`
- [ ] View logs: `./kompose.sh logs core -f`

### 5. Test Auth Stack
- [ ] Validate: `./kompose.sh env validate auth`
- [ ] View env: `./kompose.sh env show auth`
- [ ] Start: `./kompose.sh up auth`
- [ ] Check status: `./kompose.sh status auth`
- [ ] Access Keycloak: `https://auth.yourdomain.com`
- [ ] Login with admin credentials
- [ ] View logs: `./kompose.sh logs auth -f`

### 6. Test Home Stack
- [ ] Validate: `./kompose.sh env validate home`
- [ ] View env: `./kompose.sh env show home`
- [ ] Start: `./kompose.sh up home`
- [ ] Check status: `./kompose.sh status home`
- [ ] Access Home Assistant: `https://home.yourdomain.com`
- [ ] View logs: `./kompose.sh logs home -f`

### 7. Test Other Stacks
- [ ] Chain stack: `./kompose.sh up chain && ./kompose.sh status chain`
- [ ] Code stack: `./kompose.sh up code && ./kompose.sh status code`
- [ ] Proxy stack: `./kompose.sh up proxy && ./kompose.sh status proxy`
- [ ] VPN stack: `./kompose.sh up vpn && ./kompose.sh status vpn`
- [ ] Messaging stack: `./kompose.sh up messaging && ./kompose.sh status messaging`
- [ ] Custom stacks as needed

### 8. Verify All Services
- [ ] Check all containers: `docker ps`
- [ ] Check all stacks status: `./kompose.sh status`
- [ ] Verify networking: `docker network inspect kompose`
- [ ] Check volumes: `docker volume ls | grep core`
- [ ] Review logs for errors: `./kompose.sh logs <stack>`

## Post-Migration

### Documentation Updates
- [ ] Review updated core stack docs: `_docs/content/5.stacks/core.md`
- [ ] Update other stack documentation as needed
- [ ] Review migration guide: `_docs/content/3.guide/environment-migration.md`
- [ ] Review configuration reference: `_docs/content/4.reference/stack-configuration.md`

### Git Commit
- [ ] Stage new files:
  ```bash
  git add .env
  git add kompose-env.sh
  git add kompose-stack.sh  
  git add migrate-to-centralized-env.sh
  git add _docs/content/
  git add MIGRATION_SUMMARY.md
  git add ENV_QUICK_REFERENCE.md
  git add .gitignore
  ```
- [ ] Verify secrets.env NOT staged: `git status | grep secrets.env`
- [ ] Commit: `git commit -m "feat: centralized environment configuration system"`
- [ ] Push: `git push`

### Cleanup (Optional)
- [ ] Remove `.env.new` if migration successful: `rm .env.new`
- [ ] Archive old backups after verification
- [ ] Clean up temp files: `./kompose.sh cleanup`

## Verification Tests

### Environment Loading
- [ ] Test `./kompose.sh env show <stack>` for each stack
- [ ] Test `./kompose.sh env validate <stack>` for each stack
- [ ] Verify `.env.generated` files created correctly
- [ ] Check no errors in generated configs

### Stack Operations
- [ ] Test `./kompose.sh up <stack>` works for all stacks
- [ ] Test `./kompose.sh down <stack>` works
- [ ] Test `./kompose.sh restart <stack>` works
- [ ] Test `./kompose.sh logs <stack> -f` works

### Configuration Changes
- [ ] Edit a variable in `.env`
- [ ] Restart affected stack
- [ ] Verify change took effect
- [ ] Check generated `.env.generated` updated

### Secrets Handling
- [ ] Secrets loaded correctly from `secrets.env`
- [ ] Passwords work in services
- [ ] No secrets in `.env` file
- [ ] `secrets.env` not committed to git

## Troubleshooting Checks

If you encounter issues:

### Environment Issues
- [ ] Check `.env` file syntax
- [ ] Verify variable names have correct prefixes
- [ ] Look for typos in variable names
- [ ] Check `secrets.env` exists and is readable
- [ ] Review generated `.env.generated` files

### Stack Issues
- [ ] Check docker-compose config: `cd <stack> && docker-compose config`
- [ ] Verify network exists: `docker network inspect kompose`
- [ ] Check container logs: `docker logs <container-name>`
- [ ] Validate environment: `./kompose.sh env validate <stack>`

### Service Issues
- [ ] Check service health: `docker ps`
- [ ] Verify port bindings: `docker ps --format "{{.Names}}\t{{.Ports}}"`
- [ ] Test connectivity: `docker exec <container> ping <other-container>`
- [ ] Check database connections

## Rollback Plan (If Needed)

If migration fails and you need to rollback:

- [ ] Stop all stacks: `./kompose.sh down`
- [ ] Restore backups from `backups/env-migration-*/`
- [ ] Copy back to stack directories: `cp backups/env-migration-*/*.env <stack>/.env`
- [ ] Restore root .env: `cp backups/env-migration-*/root.env .env`
- [ ] Restart stacks: `./kompose.sh up`
- [ ] Report issues/problems

## Success Criteria

✅ Migration is successful when:

- [ ] All stacks start without errors
- [ ] Services are accessible at their URLs
- [ ] Database connections work
- [ ] Redis caching works
- [ ] MQTT messaging works
- [ ] Logs show no configuration errors
- [ ] Can make config changes easily
- [ ] Environment validation passes
- [ ] Secrets are properly isolated

## Next Steps After Migration

### Learning
- [ ] Practice making configuration changes
- [ ] Try `./kompose.sh env show <stack>` commands
- [ ] Experiment with stack-scoped variables
- [ ] Review documentation for best practices

### Maintenance
- [ ] Set up regular backups of `.env` and `secrets.env`
- [ ] Document any custom variables added
- [ ] Keep secrets file secure
- [ ] Regular testing of environment validation

### Enhancement
- [ ] Consider adding monitoring for config changes
- [ ] Create templates for new stacks
- [ ] Document your configuration decisions
- [ ] Share knowledge with team

---

## 📊 Migration Progress

Track your overall progress:

```
Pre-Migration:     [ ] Complete
Migration Steps:   [ ] Complete
Post-Migration:    [ ] Complete
Verification:      [ ] Complete
Documentation:     [ ] Complete
```

## 🎯 Final Check

Before marking migration complete:

- [ ] ALL stacks running: `./kompose.sh status` shows all healthy
- [ ] NO errors in logs: `./kompose.sh logs <stack>` clean
- [ ] ALL services accessible: Can access web UIs
- [ ] Environment validated: All `./kompose.sh env validate <stack>` pass
- [ ] Secrets secured: `secrets.env` has permissions 600
- [ ] Changes committed: Git commit done
- [ ] Documentation read: Understand new system
- [ ] Team informed: If working with others

---

**Status:** Migration [ ] In Progress  [ ] Complete  [ ] Rolled Back

**Date Started:** _______________

**Date Completed:** _______________

**Notes:**
```
Add any notes, issues encountered, or customizations made:




```

---

**Need Help?** Refer to:
- `MIGRATION_SUMMARY.md` - Complete guide
- `ENV_QUICK_REFERENCE.md` - Quick commands
- `_docs/content/3.guide/environment-migration.md` - Detailed migration guide
- `_docs/content/4.reference/stack-configuration.md` - Configuration reference

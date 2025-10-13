# Environment Variable Verification Checklist

**Project:** Kompose  
**Date:** 2025-10-13  
**Status:** In Progress

## Quick Start

1. ✅ Review the interactive report (already generated)
2. ⬜ Read `ENV_VERIFICATION_REPORT.md` for detailed findings
3. ⬜ Run `chmod +x fix-env-production.sh`
4. ⬜ Run `./fix-env-production.sh` to apply quick fixes
5. ⬜ Complete the manual updates below
6. ⬜ Test each stack deployment

---

## Phase 1: Critical Fixes (High Priority)

### .env.production Header Fix
- ⬜ Backup current .env.production
- ⬜ Update header from "Local Development" to "Production"
- ⬜ Update usage instructions in comments
- ⬜ Verify file integrity

### Missing Environment Variables
- ⬜ Add `CORE_COMPOSE_PROJECT_NAME=core`
- ⬜ Add `AUTH_COMPOSE_PROJECT_NAME=auth`
- ⬜ Add `AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest`
- ⬜ Add `MESSAGING_MAILHOG_PORT=8025`
- ⬜ Add `MESSAGING_MAILHOG_IMAGE=mailhog/mailhog:latest`
- ⬜ Add `MESSAGING_GOTIFY_IMAGE=gotify/server:latest`
- ⬜ Add `VPN_COMPOSE_PROJECT_NAME=vpn`
- ⬜ Add `VPN_DOCKER_IMAGE=weejewel/wg-easy:latest`

---

## Phase 2: Compose File Updates (Medium Priority)

### Core Stack (`core/compose.yaml`)
- ⬜ Update `image: ${POSTGRES_IMAGE}` → `${CORE_POSTGRES_IMAGE:-postgres:16-alpine}`
- ⬜ Update `image: ${REDIS_IMAGE}` → `${CORE_REDIS_IMAGE:-redis:7-alpine}`
- ⬜ Update `image: ${MOSQUITTO_IMAGE}` → `${CORE_MOSQUITTO_IMAGE:-eclipse-mosquitto:2}`
- ⬜ Update `image: ${REDIS_COMMANDER_IMAGE}` → `${CORE_REDIS_COMMANDER_IMAGE:-rediscommander/redis-commander:latest}`
- ⬜ Add variables to .env.production

### Auth Stack (`auth/compose.yaml`)
- ⬜ Update `image: ${DOCKER_IMAGE}` → `${AUTH_DOCKER_IMAGE}`
- ⬜ Update `container_name: ${COMPOSE_PROJECT_NAME}_keycloak` → `${AUTH_COMPOSE_PROJECT_NAME}_keycloak`
- ⬜ Verify all references use AUTH_ prefix

### Messaging Stack (`messaging/compose.yaml`)
- ⬜ Update `image: ${GOTIFY_IMAGE}` → `${MESSAGING_GOTIFY_IMAGE}`
- ⬜ Update `image: ${MAILHOG_IMAGE}` → `${MESSAGING_MAILHOG_IMAGE}`
- ⬜ Verify `${GOTIFY_PORT}` references
- ⬜ Add `${MESSAGING_MAILHOG_PORT}` references

### VPN Stack (`vpn/compose.yaml`)
- ⬜ Update `image: ${DOCKER_IMAGE}` → `${VPN_DOCKER_IMAGE}`
- ⬜ Update `container_name: ${COMPOSE_PROJECT_NAME}_app` → `${VPN_COMPOSE_PROJECT_NAME}_app`
- ⬜ Update `${TRAEFIK_HOST}` → use domain.env.production variable

### Proxy Stack (`proxy/compose.yaml`)
- ⬜ Verify `${DOCKER_IMAGE}` → should be `${PROXY_TRAEFIK_IMAGE}`
- ⬜ Verify `${LOG_LEVEL}` → should be `${PROXY_TRAEFIK_LOG_LEVEL}`
- ⬜ Update .env.production with PROXY_ prefixed variables

---

## Phase 3: Additional Stack Standardization (Low Priority)

### Chain Stack
- ⬜ Consider renaming `N8N_IMAGE` → `CHAIN_N8N_IMAGE`
- ⬜ Consider renaming `SEMAPHORE_IMAGE` → `CHAIN_SEMAPHORE_IMAGE`
- ⬜ Consider renaming `SEMAPHORE_RUNNER_IMAGE` → `CHAIN_SEMAPHORE_RUNNER_IMAGE`

### Code Stack
- ⬜ Consider renaming `GITEA_IMAGE` → `CODE_GITEA_IMAGE`
- ⬜ Consider renaming `GITEA_RUNNER_IMAGE` → `CODE_GITEA_RUNNER_IMAGE`

### Home Stack
- ⬜ Consider renaming `HOMEASSISTANT_IMAGE` → `HOME_HOMEASSISTANT_IMAGE`
- ⬜ Consider renaming `MATTER_SERVER_IMAGE` → `HOME_MATTER_SERVER_IMAGE`
- ⬜ Consider renaming `ZIGBEE2MQTT_IMAGE` → `HOME_ZIGBEE2MQTT_IMAGE`
- ⬜ Consider renaming `ESPHOME_IMAGE` → `HOME_ESPHOME_IMAGE`

---

## Phase 4: Documentation Updates

### Environment Variable Documentation
- ⬜ Create `.env.production.example` with dummy values
- ⬜ Add naming convention guide to README.md
- ⬜ Document all required vs optional variables
- ⬜ Add troubleshooting section for common env issues

### Stack Documentation
- ⬜ Verify auth.md documents all AUTH_ variables
- ⬜ Verify chain.md documents all CHAIN_ variables
- ⬜ Verify code.md documents all CODE_ variables
- ⬜ Verify core.md documents all CORE_ variables
- ⬜ Verify home.md documents all HOME_ variables
- ⬜ Verify kmps.md documents all KMPS_ variables
- ⬜ Verify messaging.md documents all MESSAGING_ variables
- ⬜ Verify proxy.md documents all PROXY_ variables
- ⬜ Verify vpn.md documents all VPN_ variables

---

## Phase 5: Validation & Testing

### Pre-Deployment Validation
- ⬜ Create env validation script
- ⬜ Add validation to kompose.sh
- ⬜ Test validation with missing variables
- ⬜ Test validation with incorrect values

### Stack Deployment Testing
- ⬜ Test core stack deployment
- ⬜ Test auth stack deployment
- ⬜ Test proxy stack deployment
- ⬜ Test messaging stack deployment
- ⬜ Test kmps stack deployment
- ⬜ Test chain stack deployment
- ⬜ Test code stack deployment
- ⬜ Test home stack deployment
- ⬜ Test vpn stack deployment

### Integration Testing
- ⬜ Verify Traefik routing for all services
- ⬜ Test database connections (PostgreSQL)
- ⬜ Test Redis connections
- ⬜ Test MQTT connections (Mosquitto)
- ⬜ Test email functionality (Mailhog)
- ⬜ Test SSO authentication (Keycloak)
- ⬜ Test OAuth2 Proxy integration

### Security Verification
- ⬜ Verify all secrets are in secrets.env
- ⬜ Ensure no secrets in domain.env.production
- ⬜ Verify .gitignore includes sensitive files
- ⬜ Check file permissions on .env files
- ⬜ Review exposed ports for security

---

## Phase 6: CI/CD Integration

### Automated Checks
- ⬜ Add env validation to CI pipeline
- ⬜ Add compose file syntax checking
- ⬜ Add docker-compose config validation
- ⬜ Add security scanning for exposed secrets

### Deployment Automation
- ⬜ Create production deployment workflow
- ⬜ Add rollback procedures
- ⬜ Document deployment process
- ⬜ Test deployment automation

---

## Completion Criteria

### Must Have (Before Production)
- ✅ All critical issues fixed
- ⬜ All missing variables added
- ⬜ All compose files updated
- ⬜ Full stack deployment tested
- ⬜ Documentation updated

### Should Have (Within 1 Week)
- ⬜ Naming conventions standardized
- ⬜ Validation scripts created
- ⬜ CI/CD integration completed
- ⬜ .env.example files created

### Nice to Have (Future Enhancement)
- ⬜ Automated env generation
- ⬜ Environment variable UI
- ⬜ Real-time validation
- ⬜ Configuration templates

---

## Notes & Issues

### Known Issues
1. .env.production header incorrectly identifies file as local development
2. Several compose files use generic variable names without stack prefix
3. Some variables defined in .env.production but not used in compose files

### Decisions Made
- Decided to use STACK_VARIABLE_NAME naming convention
- Keep backward compatibility where possible
- Add defaults in compose files for optional variables

### Questions / Blockers
- [ ] Should we migrate all existing deployments to new variable names?
- [ ] Should we maintain backward compatibility or force breaking change?
- [ ] Timeline for completing all phases?

---

## Sign-off

- [ ] **Technical Review** - Verified by: _____________ Date: _______
- [ ] **Security Review** - Verified by: _____________ Date: _______
- [ ] **Testing Complete** - Verified by: _____________ Date: _______
- [ ] **Documentation Complete** - Verified by: _____________ Date: _______
- [ ] **Production Ready** - Approved by: _____________ Date: _______

---

## Resources

- **Main Report**: `ENV_VERIFICATION_REPORT.md`
- **Quick Fix Script**: `fix-env-production.sh`
- **Interactive Report**: View in browser (already generated)
- **Test Suite**: `__tests/` directory
- **Documentation**: `_docs/content/5.stacks/`

---

**Last Updated**: 2025-10-13  
**Next Review**: After Phase 1 completion

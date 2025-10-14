# Documentation Cleanup & Migration Plan

## Overview
This plan consolidates root markdown files into `_docs/content/` and ensures documentation consistency across the Kompose project.

## Root Markdown Files Analysis

### Files to Migrate to _docs/content/3.guide/

1. **CUSTOM_STACK_MANAGEMENT.md** → `custom-stacks.md`
   - Comprehensive guide for custom stack management
   - Location: `_docs/content/3.guide/custom-stacks.md`

2. **STARTUP_ORDER.md** → Integrate into `stack-management.md`
   - Stack startup/shutdown ordering
   - Add as section in existing guide

3. **SECRETS_MANAGEMENT.md** → `secrets.md`
   - Consolidate all SECRETS_*.md files
   - Location: `_docs/content/3.guide/secrets.md`

### Files to Migrate to _docs/content/4.reference/

1. **ENV_REFERENCE.md** → `environment-variables.md`
   - Complete environment variables reference
   - Location: `_docs/content/4.reference/environment-variables.md`

2. **DATABASE_HOST_CONFIGURATION.md** → Integrate into existing `database.md`
   - Add as "Database Connectivity" section

### Files to Archive (Implementation Notes)

Move to `_docs/archive/` directory:
- ENVIRONMENT_CONFIGURATION_SOLUTION.md
- ENVIRONMENT_GENERATION_FIX.md
- ENVIRONMENT_SETUP_FIX.md
- ENVIRONMENT_SOLUTION_SUMMARY.md
- ENV_CHECKLIST.md
- ENV_CORRUPTION_FIX.md
- ENV_FILE_GENERATION_FIX.md
- ENV_VERIFICATION_REPORT.md
- FINAL_SUMMARY.md
- FINAL_SUMMARY_V2.md
- GENERATOR_IMPLEMENTATION.md
- IMPLEMENTATION_SUMMARY.md
- SECRETS_FIX.md
- SECRETS_FIX_SUMMARY.md
- SECRETS_IMPLEMENTATION_SUMMARY.md
- SECRETS_QUICK_REFERENCE.md
- SECRETS_README.md
- SECRETS_WARNING_FIX.md
- TRAEFIK_HOST_FIX_COMPLETE.md
- TRAEFIK_HOST_URL_FIX.md
- VERIFICATION_CHECKLIST.md
- WATCH_STACK_CONFIGURATION.md

### Files to Keep in Root

- **README.md** - Main project readme
- **LICENSE** - Project license
- **LOCAL_DEVELOPMENT.md.bak** - Backup file (consider removing)

## Migration Steps

### Step 1: Create New Documentation Files

1. Create `_docs/content/3.guide/custom-stacks.md`
2. Create `_docs/content/3.guide/secrets.md`
3. Create `_docs/content/4.reference/environment-variables.md`
4. Create `_docs/archive/` directory

### Step 2: Consolidate Content

1. **Secrets Management** - Merge:
   - SECRETS_MANAGEMENT.md (main content)
   - SECRETS_QUICK_REFERENCE.md (commands section)
   - SECRETS_README.md (overview)
   - Remove fix/implementation notes

2. **Environment Variables** - Use:
   - ENV_REFERENCE.md (complete reference)
   - Update with any missing stacks

3. **Custom Stacks** - Use:
   - CUSTOM_STACK_MANAGEMENT.md (as-is, just format)

4. **Startup Order** - Integrate:
   - Add to existing stack-management.md as new section

5. **Database Host** - Integrate:
   - Add to existing database.md as connectivity section

### Step 3: Update Cross-References

1. Update README.md links to point to new locations
2. Update internal documentation cross-references
3. Ensure consistency in formatting and terminology

### Step 4: Archive Old Files

1. Create `_docs/archive/implementation-notes/` directory
2. Move all fix/implementation files there
3. Add README explaining the archive

### Step 5: Clean Root Directory

1. Remove duplicated content files
2. Keep only essential root documentation
3. Update .gitignore if needed

## Expected Directory Structure After Cleanup

```
kompose/
├── README.md                              # Keep - main readme
├── LICENSE                                # Keep - license
├── _docs/
│   ├── content/
│   │   ├── 1.index.md
│   │   ├── 2.installation.md
│   │   ├── 3.guide/
│   │   │   ├── index.md
│   │   │   ├── quick-start.md
│   │   │   ├── initialization.md
│   │   │   ├── environment-setup.md
│   │   │   ├── stack-management.md       # Updated with startup order
│   │   │   ├── custom-stacks.md          # NEW
│   │   │   ├── secrets.md                # NEW - consolidated
│   │   │   ├── database.md               # Updated with connectivity
│   │   │   └── ...existing guides...
│   │   ├── 4.reference/
│   │   │   ├── cli.md
│   │   │   ├── environment.md
│   │   │   ├── environment-variables.md  # NEW - complete reference
│   │   │   └── ...existing references...
│   │   └── 5.stacks/
│   │       └── ...stack docs...
│   └── archive/
│       └── implementation-notes/         # NEW - archived files
│           ├── README.md
│           └── ...fix and implementation docs...
└── ...other project files...
```

## Consistency Checks

### Formatting Standards
- Use consistent markdown headers (##, ###, ####)
- Use code blocks with language tags
- Use tables for structured data
- Use callouts/alerts for important info
- Include navigation hints

### Content Standards
- Each guide should have: Overview, Prerequisites, Step-by-step instructions, Examples, Troubleshooting
- Each reference should have: Description, Syntax, Parameters, Examples
- Use consistent terminology across all docs
- Include version info where relevant

### Cross-Reference Standards
- Use relative links within _docs/content/
- External links should use absolute URLs
- Verify all links work after migration

## Validation Checklist

- [ ] All root MD files reviewed
- [ ] Content migrated to appropriate locations
- [ ] Implementation notes archived
- [ ] Cross-references updated
- [ ] README.md links verified
- [ ] Formatting consistency checked
- [ ] No duplicate content
- [ ] All examples tested
- [ ] Navigation structure clear
- [ ] Search functionality works (if applicable)

## Timeline

1. **Create new files** - 30 min
2. **Migrate content** - 2 hours
3. **Update cross-references** - 30 min
4. **Archive old files** - 15 min
5. **Validation** - 30 min
6. **Final review** - 15 min

**Total estimated time: ~4 hours**

## Notes

- Keep original files until migration is validated
- Create backup before making changes
- Test documentation site after migration
- Consider adding changelog entry

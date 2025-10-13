# Generated Stack Tests

This directory contains automatically generated test files for custom stacks created with the `kompose generate` command.

## Overview

When you generate a custom stack using:
```bash
./kompose.sh generate myapp
```

A corresponding test file is created here:
```
__tests/generated/
└── test-myapp.sh
```

## Test File Contents

Each generated test includes:

### Compose Validation
```bash
test_myapp_compose_valid() {
    cd "+custom/myapp"
    assert_true "docker compose config > /dev/null 2>&1" \
        "myapp compose.yaml should be valid"
}
```

### Environment Checks
```bash
test_myapp_env_exists() {
    assert_file_exists "+custom/myapp/.env" \
        "myapp .env file should exist"
}
```

### Network Configuration
```bash
test_myapp_network_configured() {
    cd "+custom/myapp"
    assert_contains "$(docker compose config)" "kompose" \
        "myapp should use kompose network"
}
```

### Traefik Integration
```bash
test_myapp_traefik_labels() {
    cd "+custom/myapp"
    assert_contains "$(docker compose config)" "traefik.enable" \
        "myapp should have Traefik labels"
}
```

## Running Tests

### Test Specific Stack

```bash
./kompose.sh test -t myapp
```

### Test All Generated Stacks

```bash
./kompose.sh test
```

## See Also

- [Testing Guide](/guide/testing)
- [Generator Documentation](/guide/generator)

---

**Location:** `__tests/generated/`  
**Generator:** `kompose-generate.sh`  
**Run Tests:** `./kompose.sh test`

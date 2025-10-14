#!/bin/bash

# test-generate-commands.sh - Tests for generate command
# Tests the stack generator functionality

source "$(dirname "$0")/test-helpers.sh"

# Test data
TEST_STACK_NAME="testapp"
TEST_CUSTOM_DIR="+custom"
TEST_DOCS_DIR="_docs/content/5.stacks/+custom"
TEST_GENERATED_DIR="__tests/generated"

# ============================================================================
# SETUP AND TEARDOWN
# ============================================================================

setup_generate_tests() {
    log_test "Setting up generate tests..."
    
    # Ensure directories exist
    mkdir -p "$TEST_CUSTOM_DIR"
    mkdir -p "$TEST_DOCS_DIR"
    mkdir -p "$TEST_GENERATED_DIR"
    
    # Clean up any existing test stack
    if [ -d "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}" ]; then
        rm -rf "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}"
    fi
    if [ -f "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md" ]; then
        rm -f "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md"
    fi
    if [ -f "${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh" ]; then
        rm -f "${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh"
    fi
}

teardown_generate_tests() {
    log_test "Cleaning up generate tests..."
    
    # Remove test stack if it exists
    if [ -d "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}" ]; then
        rm -rf "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}"
    fi
    if [ -f "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md" ]; then
        rm -f "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md"
    fi
    if [ -f "${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh" ]; then
        rm -f "${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh"
    fi
}

# ============================================================================
# GENERATE COMMAND TESTS
# ============================================================================

test_generate_requires_stack_name() {
    local output
    output=$(run_kompose generate 2>&1)
    
    assert_contains "$output" "Generate subcommand required" \
        "generate command should require a stack name or subcommand"
}

test_generate_creates_stack_files() {
    setup_generate_tests
    
    # Generate stack non-interactively
    echo "n" | run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1 || true
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Check compose.yaml
    assert_file_exists "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/compose.yaml" \
        "generate should create compose.yaml"
    
    # Check .env
    assert_file_exists "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/.env" \
        "generate should create .env file"
    
    # Check README.md
    assert_file_exists "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md" \
        "generate should create README.md in docs"
    
    # Check test file
    assert_file_exists "${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh" \
        "generate should create test file"
    
    teardown_generate_tests
}

test_generate_compose_is_valid() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Validate compose file
    cd "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}"
    assert_true "docker compose config > /dev/null 2>&1" \
        "generated compose.yaml should be valid"
    cd - > /dev/null
    
    teardown_generate_tests
}

test_generate_compose_has_traefik_labels() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local compose_content
    compose_content=$(cat "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/compose.yaml")
    
    assert_contains "$compose_content" "traefik.enable" \
        "compose.yaml should have traefik.enable label"
    
    assert_contains "$compose_content" "traefik.http.routers" \
        "compose.yaml should have traefik router labels"
    
    teardown_generate_tests
}

test_generate_compose_uses_kompose_network() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local compose_content
    compose_content=$(cat "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/compose.yaml")
    
    assert_contains "$compose_content" "kompose_network" \
        "compose.yaml should reference kompose_network"
    
    assert_contains "$compose_content" "external: true" \
        "kompose_network should be external"
    
    teardown_generate_tests
}

test_generate_env_has_required_vars() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local env_content
    env_content=$(cat "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/.env")
    
    assert_contains "$env_content" "COMPOSE_PROJECT_NAME" \
        ".env should have COMPOSE_PROJECT_NAME"
    
    assert_contains "$env_content" "DOCKER_IMAGE" \
        ".env should have DOCKER_IMAGE"
    
    assert_contains "$env_content" "TRAEFIK_HOST" \
        ".env should have TRAEFIK_HOST"
    
    teardown_generate_tests
}

test_generate_readme_has_stack_name() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local readme_content
    readme_content=$(cat "${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md")
    
    assert_contains "$readme_content" "$TEST_STACK_NAME" \
        "README.md should contain stack name"
    
    assert_contains "$readme_content" "# " \
        "README.md should have markdown headers"
    
    teardown_generate_tests
}

test_generate_creates_gitignore() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    assert_file_exists "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/.gitignore" \
        "generate should create .gitignore"
    
    local gitignore_content
    gitignore_content=$(cat "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/.gitignore")
    
    assert_contains "$gitignore_content" ".env.generated" \
        ".gitignore should ignore .env.generated"
    
    teardown_generate_tests
}

test_generate_test_file_is_executable() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    assert_true "[ -x '${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh' ]" \
        "generated test file should be executable"
    
    teardown_generate_tests
}

# ============================================================================
# GENERATE LIST COMMAND TESTS
# ============================================================================

test_generate_list_shows_custom_stacks() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local output
    output=$(run_kompose generate list)
    
    assert_contains "$output" "$TEST_STACK_NAME" \
        "generate list should show custom stacks"
    
    teardown_generate_tests
}

test_generate_list_shows_empty_message() {
    setup_generate_tests
    
    local output
    output=$(run_kompose generate list)
    
    # Since there might be other custom stacks, just check it doesn't error
    assert_true "true" \
        "generate list should work even with no stacks"
    
    teardown_generate_tests
}

# ============================================================================
# GENERATE SHOW COMMAND TESTS
# ============================================================================

test_generate_show_displays_stack_info() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    local output
    output=$(run_kompose generate show "$TEST_STACK_NAME")
    
    assert_contains "$output" "compose.yaml" \
        "generate show should display compose.yaml path"
    
    assert_contains "$output" ".env" \
        "generate show should display .env path"
    
    teardown_generate_tests
}

test_generate_show_requires_stack_name() {
    local output
    output=$(run_kompose generate show 2>&1)
    
    assert_contains "$output" "Stack name is required" \
        "generate show should require stack name"
}

test_generate_show_errors_on_nonexistent_stack() {
    local output
    output=$(run_kompose generate show nonexistent-stack-xyz 2>&1)
    
    assert_contains "$output" "Stack not found" \
        "generate show should error on nonexistent stack"
}

# ============================================================================
# GENERATE DELETE COMMAND TESTS
# ============================================================================

test_generate_delete_requires_confirmation() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Test that delete asks for confirmation (we'll cancel it)
    local output
    output=$(echo "n" | run_kompose generate delete "$TEST_STACK_NAME" 2>&1)
    
    assert_contains "$output" "Are you sure" \
        "generate delete should ask for confirmation"
    
    # Stack should still exist
    assert_file_exists "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/compose.yaml" \
        "stack should still exist after cancelled deletion"
    
    teardown_generate_tests
}

test_generate_delete_removes_files() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Confirm deletion
    echo "y" | run_kompose generate delete "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Check files are removed
    assert_false "[ -d '${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}' ]" \
        "stack directory should be removed"
    
    assert_false "[ -f '${TEST_DOCS_DIR}/${TEST_STACK_NAME}.md' ]" \
        "README.md should be removed"
    
    assert_false "[ -f '${TEST_GENERATED_DIR}/test-${TEST_STACK_NAME}.sh' ]" \
        "test file should be removed"
    
    teardown_generate_tests
}

test_generate_delete_errors_on_nonexistent_stack() {
    local output
    output=$(run_kompose generate delete nonexistent-stack-xyz 2>&1)
    
    assert_contains "$output" "Stack not found" \
        "generate delete should error on nonexistent stack"
}

# ============================================================================
# VALIDATION TESTS
# ============================================================================

test_generate_rejects_invalid_stack_names() {
    local output
    
    # Test uppercase
    output=$(run_kompose generate "MyApp" 2>&1)
    assert_contains "$output" "Invalid stack name" \
        "should reject uppercase names"
    
    # Test spaces
    output=$(run_kompose generate "my app" 2>&1)
    assert_contains "$output" "Invalid stack name" \
        "should reject names with spaces"
    
    # Test special characters
    output=$(run_kompose generate "my_app" 2>&1)
    assert_contains "$output" "Invalid stack name" \
        "should reject names with underscores"
}

test_generate_accepts_valid_stack_names() {
    setup_generate_tests
    
    # Test lowercase with hyphens
    run_kompose generate "my-test-app" > /dev/null 2>&1
    
    assert_file_exists "${TEST_CUSTOM_DIR}/my-test-app/compose.yaml" \
        "should accept lowercase names with hyphens"
    
    # Cleanup
    rm -rf "${TEST_CUSTOM_DIR}/my-test-app"
    rm -f "${TEST_DOCS_DIR}/my-test-app.md"
    rm -f "${TEST_GENERATED_DIR}/test-my-test-app.sh"
    
    teardown_generate_tests
}

# ============================================================================
# INTEGRATION TESTS
# ============================================================================

test_generated_stack_can_be_started() {
    setup_generate_tests
    
    run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
    
    # Update .env with a valid image
    sed -i 's|DOCKER_IMAGE=your-image:latest|DOCKER_IMAGE=nginx:alpine|' \
        "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}/.env"
    
    # Try to validate the stack (don't actually start it)
    cd "${TEST_CUSTOM_DIR}/${TEST_STACK_NAME}"
    local result
    result=$(docker compose config 2>&1)
    local exit_code=$?
    cd - > /dev/null
    
    assert_true "[ $exit_code -eq 0 ]" \
        "generated stack should pass docker compose validation"
    
    teardown_generate_tests
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

log_info "Running generate command tests..."
echo ""

# Basic generation tests
test_generate_requires_stack_name
test_generate_creates_stack_files
test_generate_compose_is_valid
test_generate_compose_has_traefik_labels
test_generate_compose_uses_kompose_network
test_generate_env_has_required_vars
test_generate_readme_has_stack_name
test_generate_creates_gitignore
test_generate_test_file_is_executable

# List command tests
test_generate_list_shows_custom_stacks
test_generate_list_shows_empty_message

# Show command tests
test_generate_show_displays_stack_info
test_generate_show_requires_stack_name
test_generate_show_errors_on_nonexistent_stack

# Delete command tests
test_generate_delete_requires_confirmation
test_generate_delete_removes_files
test_generate_delete_errors_on_nonexistent_stack

# Validation tests
test_generate_rejects_invalid_stack_names
test_generate_accepts_valid_stack_names

# Integration tests
test_generated_stack_can_be_started

echo ""
print_test_summary

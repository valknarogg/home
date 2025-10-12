#!/bin/bash

# kompose-tag.sh - Git Tag Deployment Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# GIT TAG DEPLOYMENT FUNCTIONS
# ============================================================================

validate_tag_inputs() {
    if [[ -n "$TAG_SERVICE" && ! -v "TAG_SERVICES[$TAG_SERVICE]" ]]; then
        log_error "Invalid service: $TAG_SERVICE"
        log_info "Available services: ${!TAG_SERVICES[@]}"
        exit 1
    fi

    if [[ -n "$TAG_ENV" && ! -v "ENVIRONMENTS[$TAG_ENV]" ]]; then
        log_error "Invalid environment: $TAG_ENV"
        log_info "Available environments: ${!ENVIRONMENTS[@]}"
        exit 1
    fi

    if [[ -n "$TAG_VERSION" && ! "$TAG_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        log_error "Invalid version format: $TAG_VERSION (expected: X.Y.Z)"
        exit 1
    fi
}

generate_tag_name() {
    local service=$1
    local env=$2
    local version=$3
    
    echo "${TAG_SERVICES[$service]}${version}-${env}"
}

tag_create() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Creating tag: $tag_name at commit $commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would create tag $tag_name"
        return 0
    fi
    
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Tag $tag_name already exists. Deleting..."
            git tag -d "$tag_name"
        else
            log_error "Tag $tag_name already exists. Use -f to force."
            exit 1
        fi
    fi
    
    git tag -a "$tag_name" "$commit" -m "$message"
    log_success "Tag created: $tag_name"
}

tag_push() {
    local tag_name=$1
    
    log_tag "Pushing tag: $tag_name to remote"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would push tag $tag_name"
        return 0
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        git push origin "$tag_name" --force
    else
        git push origin "$tag_name"
    fi
    
    log_success "Tag pushed: $tag_name"
}

tag_delete() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_warning "Deleting tag: $tag_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would delete tag $tag_name"
        return 0
    fi
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to delete production tag $tag_name? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    git tag -d "$tag_name" 2>/dev/null || log_warning "Local tag not found"
    git push origin ":refs/tags/$tag_name" 2>/dev/null || log_warning "Remote tag not found"
    
    log_success "Tag deleted: $tag_name"
}

tag_move() {
    local service=$1
    local env=$2
    local version=$3
    local new_commit=$4
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Moving tag $tag_name to commit $new_commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would move tag $tag_name to $new_commit"
        return 0
    fi
    
    git tag -d "$tag_name" 2>/dev/null || true
    git push origin ":refs/tags/$tag_name" 2>/dev/null || true
    
    tag_create "$service" "$env" "$version" "$new_commit" "Moved tag to $new_commit"
    tag_push "$tag_name"
}

tag_list() {
    local service=${1:-}
    
    echo ""
    if [[ -z "$service" ]]; then
        log_tag "All deployment tags:"
        git tag -l "*-v*-*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    else
        if [[ ! -v "TAG_SERVICES[$service]" ]]; then
            log_error "Invalid service: $service"
            log_info "Available services: ${!TAG_SERVICES[@]}"
            exit 1
        fi
        local prefix="${TAG_SERVICES[$service]}"
        log_tag "Tags for $service:"
        git tag -l "${prefix}*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    fi
    echo ""
}

trigger_n8n_deployment() {
    local service=$1
    local env=$2
    local version=$3
    local tag_name=$4
    
    local webhook_url="${N8N_WEBHOOK_BASE}/deploy-${service}"
    
    log_info "Triggering n8n workflow for $service deployment"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would trigger webhook $webhook_url"
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "service": "$service",
    "environment": "$env",
    "version": "$version",
    "tag": "$tag_name",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "author": "$(git config user.name 2>/dev/null || echo 'unknown')",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "registry": "${REGISTRY:-localhost:5000}"
}
EOF
)
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$payload" \
            "$webhook_url" 2>&1 || echo "ERROR")
        
        if [[ "$response" == "ERROR" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Failed to trigger n8n webhook (is n8n running?)"
        else
            log_success "n8n webhook triggered successfully"
        fi
    else
        log_warning "curl not found, skipping webhook trigger"
    fi
}

tag_deploy() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Starting deployment workflow for $service v$version to $env"
    
    # Create and push tag
    tag_create "$service" "$env" "$version" "$commit" "$message"
    tag_push "$tag_name"
    
    # Trigger n8n workflow
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Deployment initiated for $service v$version to $env"
    log_info "Tag: $tag_name"
    if [[ -n "$REPO_URL" ]]; then
        log_info "Monitor deployment: ${GITEA_URL}/$(echo $REPO_URL | sed 's/.*://;s/.git$//')/actions"
    fi
}

tag_rollback() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    if ! git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "Tag $tag_name does not exist"
        exit 1
    fi
    
    local commit=$(git rev-parse "$tag_name")
    
    log_warning "Rolling back $service in $env to version $version (commit: $commit)"
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to rollback production? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Rollback cancelled"
            exit 0
        fi
    fi
    
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Rollback initiated for $service to version $version in $env"
}

tag_status() {
    local service=$1
    local version=$2
    local env=$3
    
    log_tag "Checking deployment status for $service v$version in $env"
    
    if command -v curl &> /dev/null; then
        local status_url="${N8N_WEBHOOK_BASE}/deployment-status?service=${service}&version=${version}&env=${env}"
        local response=$(curl -s "$status_url" 2>/dev/null || echo "{}")
        
        if [[ "$response" == "{}" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Could not connect to n8n (is it running?)"
            log_info "Check manually: $status_url"
        else
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        fi
    else
        log_warning "curl not found, cannot check status"
    fi
}

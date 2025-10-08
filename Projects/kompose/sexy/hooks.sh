#!/usr/bin/env bash

# Hooks for sexy stack (Directus)
# Available hooks: pre_db_export, post_db_export, pre_db_import, post_db_import

# Export Directus schema snapshot before database export
hook_pre_db_export() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local snapshot_file="${SCRIPT_DIR}/${stack}/directus_schema_${timestamp}.yaml"
    
    echo "  Exporting Directus schema snapshot..."
    
    # Use docker exec to run directus schema snapshot command
    if docker exec "${COMPOSE_PROJECT_NAME}_api" npx directus schema snapshot "${snapshot_file##*/}" > /dev/null 2>&1; then
        # Move snapshot from container to host
        docker cp "${COMPOSE_PROJECT_NAME}_api:/directus/${snapshot_file##*/}" "${snapshot_file}"
        echo "  Schema snapshot saved: ${snapshot_file}"
        return 0
    else
        echo "  Warning: Could not export schema snapshot (container may not be running)"
        return 0  # Don't fail the entire export
    fi
}

# Nothing needed after export
hook_post_db_export() {
    return 0
}

# Import Directus schema snapshot before database import
hook_pre_db_import() {
    local dump_file="$1"
    
    # Look for most recent schema snapshot
    local snapshot_file=$(ls -t "${SCRIPT_DIR}/${stack}"/directus_schema_*.yaml 2>/dev/null | head -1)
    
    if [[ -z "${snapshot_file}" ]]; then
        echo "  No schema snapshot found, skipping schema import"
        return 0
    fi
    
    echo "  Importing Directus schema from: ${snapshot_file##*/}"
    
    # Copy snapshot to container
    docker cp "${snapshot_file}" "${COMPOSE_PROJECT_NAME}_api:/directus/snapshot.yaml"
    
    # Apply schema snapshot
    if docker exec "${COMPOSE_PROJECT_NAME}_api" npx directus schema apply /directus/snapshot.yaml > /dev/null 2>&1; then
        echo "  Schema snapshot applied successfully"
        return 0
    else
        echo "  Warning: Could not apply schema snapshot"
        return 0  # Don't fail the entire import
    fi
}

# Reload Directus after import
hook_post_db_import() {
    echo "  Restarting Directus to apply changes..."
    docker restart "${COMPOSE_PROJECT_NAME}_api" > /dev/null 2>&1
    return 0
}

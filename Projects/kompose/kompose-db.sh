#!/bin/bash

# kompose-db.sh - Database Management Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

db_backup() {
    local db_name=${1:-"all"}
    local backup_file=$2
    local compress=${3:-false}
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$BACKUP_DIR"
    
    if [[ "$db_name" == "all" ]]; then
        log_db "Backing up all databases..."
        for db in "${!DATABASES[@]}"; do
            db_backup "$db" "" "$compress"
        done
        log_success "All databases backed up to $BACKUP_DIR"
        return 0
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    if [[ -z "$backup_file" ]]; then
        backup_file="${BACKUP_DIR}/${db_name}_${timestamp}.sql"
        if [[ "$compress" == "true" ]]; then
            backup_file="${backup_file}.gz"
        fi
    fi
    
    log_db "Backing up database: $db_name"
    log_info "Backup file: $backup_file"
    
    if [[ "$compress" == "true" ]]; then
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" | gzip > "$backup_file"
    else
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" > "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Database $db_name backed up successfully ($size)"
    else
        log_error "Backup failed for database: $db_name"
        exit 1
    fi
}

db_restore() {
    local backup_file=$1
    local db_name=$2
    
    if [[ -z "$backup_file" ]]; then
        log_error "Backup file required"
        log_info "Usage: kompose db restore -f BACKUP_FILE [-d DATABASE]"
        exit 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    # Auto-detect database name from filename if not provided
    if [[ -z "$db_name" ]]; then
        db_name=$(basename "$backup_file" | sed -E 's/^([^_]+)_.*/\1/')
        log_info "Auto-detected database: $db_name"
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "Restoring database: $db_name from $backup_file"
    read -p "This will overwrite the existing database. Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    log_db "Dropping existing database..."
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_db "Restoring from backup..."
    if [[ "$backup_file" == *.gz ]]; then
        gunzip -c "$backup_file" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name"
    else
        docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name" < "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_success "Database $db_name restored successfully"
    else
        log_error "Restore failed"
        exit 1
    fi
}

db_list() {
    echo ""
    log_db "Available database backups:"
    echo ""
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_warning "No backup directory found: $BACKUP_DIR"
        return 0
    fi
    
    find "$BACKUP_DIR" -name "*.sql" -o -name "*.sql.gz" | sort -r | while read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "  📦 $(basename $file) - $size - $date"
    done
    
    echo ""
}

db_status() {
    log_db "Database status:"
    echo ""
    
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        log_error "PostgreSQL container is not running"
        log_info "Start with: kompose up core"
        exit 1
    fi
    
    log_success "PostgreSQL container is running"
    echo ""
    
    log_info "Available databases:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "\l" | grep -E "^\s*(kompose|n8n|semaphore|gitea)" || echo "No databases found"
    echo ""
    
    log_info "Database sizes:"
    for db in "${!DATABASES[@]}"; do
        local size=$(docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | xargs)
        if [[ -n "$size" ]]; then
            echo -e "  ${CYAN}$db${NC}: $size - ${DATABASES[$db]}"
        fi
    done
    echo ""
    
    log_info "Active connections:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;"
    echo ""
}

db_exec() {
    local db_name=$1
    local sql_command=$2
    
    if [[ -z "$db_name" || -z "$sql_command" ]]; then
        log_error "Database name and SQL command required"
        log_info "Usage: kompose db exec -d DATABASE \"SQL COMMAND\""
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Executing SQL on database: $db_name"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" -c "$sql_command"
}

db_shell() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Opening shell for database: $db_name"
    log_info "Type \\q to exit"
    echo ""
    
    docker exec -it "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name"
}

db_migrate() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Running migrations for database: $db_name"
    
    case $db_name in
        n8n)
            log_info "n8n handles migrations automatically on startup"
            log_info "Restart n8n: kompose restart chain"
            ;;
        gitea)
            log_info "Gitea handles migrations automatically on startup"
            log_info "Restart gitea: kompose restart chain"
            ;;
        kompose)
            local migrations_dir="./migrations"
            if [[ ! -d "$migrations_dir" ]]; then
                log_warning "No migrations directory found: $migrations_dir"
                return 0
            fi
            
            log_info "Applying migrations from $migrations_dir"
            for migration in "$migrations_dir"/*.sql; do
                if [[ -f "$migration" ]]; then
                    log_info "Applying: $(basename $migration)"
                    docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" < "$migration"
                fi
            done
            log_success "Migrations completed"
            ;;
    esac
}

db_reset() {
    local db_name=$1
    
    if [[ -z "$db_name" ]]; then
        log_error "Database name required"
        log_info "Usage: kompose db reset -d DATABASE"
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "⚠️  WARNING: This will DELETE ALL DATA in database: $db_name"
    read -p "Type the database name to confirm: " confirm
    
    if [[ "$confirm" != "$db_name" ]]; then
        log_info "Reset cancelled"
        exit 0
    fi
    
    log_db "Resetting database: $db_name"
    
    # Create backup first
    log_info "Creating backup before reset..."
    db_backup "$db_name" "" false
    
    # Drop and recreate
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_success "Database $db_name has been reset"
    log_info "Backup saved to: $BACKUP_DIR"
}

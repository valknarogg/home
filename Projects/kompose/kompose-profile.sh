#!/bin/bash

# kompose-profile.sh - Profile management module
# Handles configuration profiles with environment overrides and stack configurations

# ============================================================================
# PROFILE FILE MANAGEMENT
# ============================================================================

PROFILE_FILE="${PROFILE_FILE:-kompose.yml}"
CURRENT_PROFILE_FILE=".kompose-current-profile"

# Get current profile name
get_current_profile() {
    if [ -f "$CURRENT_PROFILE_FILE" ]; then
        cat "$CURRENT_PROFILE_FILE"
    else
        echo "default"
    fi
}

# Set current profile
set_current_profile() {
    local profile_name=$1
    echo "$profile_name" > "$CURRENT_PROFILE_FILE"
}

# Check if profile exists
profile_exists() {
    local profile_name=$1
    
    if [ ! -f "$PROFILE_FILE" ]; then
        return 1
    fi
    
    # Check if profile section exists in YAML
    if grep -q "^  ${profile_name}:" "$PROFILE_FILE"; then
        return 0
    fi
    
    return 1
}

# List all profiles
list_profiles() {
    if [ ! -f "$PROFILE_FILE" ]; then
        log_warning "No profiles configured yet"
        echo ""
        echo "Create your first profile with:"
        echo "  ${CYAN}./kompose.sh profile create <name>${NC}"
        echo ""
        return
    fi
    
    local current=$(get_current_profile)
    
    log_info "Available Profiles:"
    echo ""
    
    # Parse YAML and extract profiles
    awk '
    /^  [a-zA-Z0-9_-]+:$/ {
        profile = $1
        gsub(/:/, "", profile)
        gsub(/^  /, "", profile)
        profiles[profile] = 1
    }
    /^    description:/ {
        descriptions[profile] = substr($0, index($0, $2))
    }
    /^    stacks:/ {
        in_stacks = 1
        stack_list = ""
        next
    }
    in_stacks && /^      - / {
        stack = $2
        if (stack_list == "") {
            stack_list = stack
        } else {
            stack_list = stack_list ", " stack
        }
        next
    }
    in_stacks && !/^      / {
        stacks[profile] = stack_list
        in_stacks = 0
    }
    END {
        for (p in profiles) {
            desc = descriptions[p] ? descriptions[p] : "No description"
            stack = stacks[p] ? stacks[p] : "No stacks"
            printf "  %s\n", p
            printf "    Description: %s\n", desc
            printf "    Stacks: %s\n", stack
            printf "\n"
        }
    }
    ' "$PROFILE_FILE" | while IFS= read -r line; do
        if [[ "$line" =~ ^\ \ ([a-zA-Z0-9_-]+)$ ]]; then
            local profile_name="${BASH_REMATCH[1]}"
            if [ "$profile_name" = "$current" ]; then
                echo -e "${GREEN}✓ ${CYAN}$line${NC} ${YELLOW}(active)${NC}"
            else
                echo -e "  ${CYAN}$line${NC}"
            fi
        else
            echo "$line"
        fi
    done
    
    echo ""
    echo "Active profile: ${GREEN}$current${NC}"
    echo ""
    echo "Commands:"
    echo "  • Switch profile:  ${CYAN}./kompose.sh profile use <name>${NC}"
    echo "  • Show details:    ${CYAN}./kompose.sh profile show <name>${NC}"
    echo "  • Create profile:  ${CYAN}./kompose.sh profile create <name>${NC}"
}

# ============================================================================
# PROFILE CREATION AND EDITING
# ============================================================================

# Create a new profile interactively
create_profile() {
    local profile_name=$1
    
    if [ -z "$profile_name" ]; then
        log_error "Profile name is required"
        echo "Usage: ./kompose.sh profile create <name>"
        exit 1
    fi
    
    # Validate profile name
    if [[ ! "$profile_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid profile name. Use only letters, numbers, hyphens, and underscores"
        exit 1
    fi
    
    if profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' already exists"
        echo ""
        echo "Use: ./kompose.sh profile edit $profile_name"
        exit 1
    fi
    
    log_info "Creating Profile: $profile_name"
    echo ""
    
    # Get profile description
    read -p "Enter profile description: " -r description
    description=${description:-"No description"}
    
    # Ask about stacks
    echo ""
    log_info "Select stacks to include in this profile"
    echo "Available stacks:"
    local idx=1
    local available_stacks=()
    for stack in "${!STACKS[@]}"; do
        echo "  ${idx}. ${stack} - ${STACKS[$stack]}"
        available_stacks+=("$stack")
        ((idx++))
    done
    echo ""
    read -p "Enter stack numbers (comma-separated, e.g., 1,2,3) or press Enter to skip: " -r stack_selection
    
    local selected_stacks=()
    if [ -n "$stack_selection" ]; then
        IFS=',' read -ra NUMBERS <<< "$stack_selection"
        for num in "${NUMBERS[@]}"; do
            num=$(echo "$num" | tr -d ' ')
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#available_stacks[@]}" ]; then
                selected_stacks+=("${available_stacks[$((num-1))]}")
            fi
        done
    fi
    
    # Ask about environment mode
    echo ""
    log_info "Select environment mode"
    echo "  1. Local Development (localhost)"
    echo "  2. Production (domain-based)"
    echo "  3. Custom"
    read -p "Choose (1/2/3) [1]: " -r env_mode
    env_mode=${env_mode:-1}
    
    local env_vars=""
    local domain_vars=""
    
    case $env_mode in
        1)
            env_vars="# Local development mode
      ENVIRONMENT: local
      TRAEFIK_ENABLED: 'false'"
            ;;
        2)
            read -p "Enter your domain: " -r domain
            domain=${domain:-example.com}
            env_vars="# Production mode
      ENVIRONMENT: production
      TRAEFIK_ENABLED: 'true'"
            domain_vars="# Production domain configuration
      ROOT_DOMAIN: $domain"
            ;;
        3)
            log_info "You can edit the profile file later to add custom variables"
            ;;
    esac
    
    # Create or update profile file
    if [ ! -f "$PROFILE_FILE" ]; then
        cat > "$PROFILE_FILE" << EOF
# Kompose Profile Configuration
# This file stores different environment profiles for the Kompose stack manager

profiles:
EOF
    fi
    
    # Add the new profile
    cat >> "$PROFILE_FILE" << EOF

  $profile_name:
    description: $description
    stacks:
EOF
    
    # Add selected stacks
    if [ ${#selected_stacks[@]} -gt 0 ]; then
        for stack in "${selected_stacks[@]}"; do
            echo "      - $stack" >> "$PROFILE_FILE"
        done
    else
        echo "      # No stacks selected" >> "$PROFILE_FILE"
    fi
    
    # Add environment variables
    echo "" >> "$PROFILE_FILE"
    echo "    environment:" >> "$PROFILE_FILE"
    if [ -n "$env_vars" ]; then
        echo "$env_vars" >> "$PROFILE_FILE"
    else
        echo "      # Add custom environment variables here" >> "$PROFILE_FILE"
    fi
    
    # Add domain variables
    if [ -n "$domain_vars" ]; then
        echo "" >> "$PROFILE_FILE"
        echo "    domain:" >> "$PROFILE_FILE"
        echo "$domain_vars" >> "$PROFILE_FILE"
    fi
    
    log_success "Profile '$profile_name' created successfully!"
    echo ""
    echo "Edit profile: ${CYAN}./kompose.sh profile edit $profile_name${NC}"
    echo "Use profile:  ${CYAN}./kompose.sh profile use $profile_name${NC}"
}

# Edit profile
edit_profile() {
    local profile_name=$1
    
    if [ -z "$profile_name" ]; then
        profile_name=$(get_current_profile)
    fi
    
    if ! profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' not found"
        exit 1
    fi
    
    log_info "Opening profile '$profile_name' for editing..."
    
    # Open with preferred editor
    ${EDITOR:-nano} "$PROFILE_FILE"
    
    log_success "Profile saved"
}

# ============================================================================
# PROFILE ACTIVATION AND USAGE
# ============================================================================

# Switch to a profile
use_profile() {
    local profile_name=$1
    
    if [ -z "$profile_name" ]; then
        log_error "Profile name is required"
        echo "Usage: ./kompose.sh profile use <name>"
        exit 1
    fi
    
    if ! profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' not found"
        echo ""
        echo "Available profiles:"
        list_profiles
        exit 1
    fi
    
    log_info "Switching to profile: $profile_name"
    echo ""
    
    # Backup current configuration
    local backup_dir=$(backup_config)
    log_info "Created backup: $backup_dir"
    
    # Apply profile settings
    apply_profile "$profile_name"
    
    # Set as current profile
    set_current_profile "$profile_name"
    
    log_success "Profile '$profile_name' activated!"
    echo ""
    
    # Show what changed
    show_profile "$profile_name"
}

# Apply profile settings to environment
apply_profile() {
    local profile_name=$1
    
    log_info "Applying profile settings..."
    
    # Extract and apply environment variables
    local env_section=$(awk -v profile="$profile_name" '
    $0 ~ "^  " profile ":" {found=1; next}
    found && /^    environment:/ {in_env=1; next}
    found && in_env && /^      [A-Z_]+:/ {
        split($0, arr, ":")
        key = arr[1]
        gsub(/^      /, "", key)
        gsub(/^ +/, "", arr[2])
        gsub(/'"'"'/, "", arr[2])
        print key "=" arr[2]
        next
    }
    found && in_env && /^    [a-z]/ {exit}
    ' "$PROFILE_FILE")
    
    if [ -n "$env_section" ]; then
        # Update .env file
        while IFS='=' read -r key value; do
            if [ -n "$key" ] && [ -n "$value" ]; then
                if grep -q "^${key}=" .env 2>/dev/null; then
                    sed -i.bak "s|^${key}=.*|${key}=${value}|" .env
                else
                    echo "${key}=${value}" >> .env
                fi
                log_info "  Set ${key}=${value}"
            fi
        done <<< "$env_section"
    fi
    
    # Extract and apply domain variables
    local domain_section=$(awk -v profile="$profile_name" '
    $0 ~ "^  " profile ":" {found=1; next}
    found && /^    domain:/ {in_domain=1; next}
    found && in_domain && /^      [A-Z_]+:/ {
        split($0, arr, ":")
        key = arr[1]
        gsub(/^      /, "", key)
        gsub(/^ +/, "", arr[2])
        gsub(/'"'"'/, "", arr[2])
        print key "=" arr[2]
        next
    }
    found && in_domain && /^    [a-z]/ {exit}
    ' "$PROFILE_FILE")
    
    if [ -n "$domain_section" ]; then
        # Update domain.env file
        while IFS='=' read -r key value; do
            if [ -n "$key" ] && [ -n "$value" ]; then
                if [ -f "domain.env" ]; then
                    if grep -q "^${key}=" domain.env 2>/dev/null; then
                        sed -i.bak "s|^${key}=.*|${key}=${value}|" domain.env
                    else
                        echo "${key}=${value}" >> domain.env
                    fi
                else
                    echo "${key}=${value}" >> domain.env
                fi
                log_info "  Set domain ${key}=${value}"
            fi
        done <<< "$domain_section"
    fi
    
    log_success "Environment variables updated"
}

# Show profile details
show_profile() {
    local profile_name=$1
    
    if [ -z "$profile_name" ]; then
        profile_name=$(get_current_profile)
    fi
    
    if ! profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' not found"
        exit 1
    fi
    
    local current=$(get_current_profile)
    
    log_info "═══════════════════════════════════════════════════════════"
    log_info "  Profile: $profile_name"
    if [ "$profile_name" = "$current" ]; then
        echo -e "  ${GREEN}✓ Active${NC}"
    fi
    log_info "═══════════════════════════════════════════════════════════"
    echo ""
    
    # Extract profile details
    awk -v profile="$profile_name" '
    BEGIN {
        in_profile = 0
        in_stacks = 0
        in_env = 0
        in_domain = 0
    }
    
    $0 ~ "^  " profile ":" {
        in_profile = 1
        next
    }
    
    in_profile && /^  [a-z]/ && !/^    / {
        exit
    }
    
    in_profile && /^    description:/ {
        desc = substr($0, index($0, $2))
        print "Description: " desc
        print ""
        next
    }
    
    in_profile && /^    stacks:/ {
        in_stacks = 1
        print "Stacks:"
        next
    }
    
    in_stacks && /^      - / {
        stack = $2
        print "  • " stack
        next
    }
    
    in_stacks && !/^      / {
        in_stacks = 0
        print ""
    }
    
    in_profile && /^    environment:/ {
        in_env = 1
        print "Environment Variables:"
        next
    }
    
    in_env && /^      [A-Z_]+:/ {
        print "  " $0
        next
    }
    
    in_env && !/^      [A-Z_]/ {
        in_env = 0
        print ""
    }
    
    in_profile && /^    domain:/ {
        in_domain = 1
        print "Domain Variables:"
        next
    }
    
    in_domain && /^      [A-Z_]+:/ {
        print "  " $0
        next
    }
    
    in_domain && !/^      / {
        in_domain = 0
    }
    ' "$PROFILE_FILE"
    
    echo ""
}

# ============================================================================
# PROFILE OPERATIONS
# ============================================================================

# Delete a profile
delete_profile() {
    local profile_name=$1
    local force=$2
    
    if [ -z "$profile_name" ]; then
        log_error "Profile name is required"
        echo "Usage: ./kompose.sh profile delete <name> [-f]"
        exit 1
    fi
    
    if ! profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' not found"
        exit 1
    fi
    
    local current=$(get_current_profile)
    if [ "$profile_name" = "$current" ] && [ "$force" != "-f" ]; then
        log_error "Cannot delete active profile"
        echo ""
        echo "Switch to another profile first:"
        echo "  ./kompose.sh profile use <other-profile>"
        echo ""
        echo "Or use --force to delete anyway:"
        echo "  ./kompose.sh profile delete $profile_name -f"
        exit 1
    fi
    
    log_warning "Deleting profile: $profile_name"
    
    if [ "$force" != "-f" ]; then
        read -p "Are you sure? (y/N): " -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    # Create backup
    cp "$PROFILE_FILE" "${PROFILE_FILE}.bak"
    
    # Remove profile from YAML
    awk -v profile="$profile_name" '
    BEGIN { in_profile = 0; skip = 0 }
    
    $0 ~ "^  " profile ":" {
        in_profile = 1
        skip = 1
        next
    }
    
    in_profile && /^  [a-z]/ && !/^    / {
        in_profile = 0
        skip = 0
    }
    
    !skip { print }
    ' "${PROFILE_FILE}.bak" > "$PROFILE_FILE"
    
    log_success "Profile '$profile_name' deleted"
    
    # If this was the current profile, switch to default
    if [ "$profile_name" = "$current" ]; then
        log_info "Switched to default profile"
        set_current_profile "default"
    fi
}

# Copy/clone a profile
copy_profile() {
    local source_profile=$1
    local new_profile=$2
    
    if [ -z "$source_profile" ] || [ -z "$new_profile" ]; then
        log_error "Source and destination profile names are required"
        echo "Usage: ./kompose.sh profile copy <source> <new-name>"
        exit 1
    fi
    
    if ! profile_exists "$source_profile"; then
        log_error "Source profile '$source_profile' not found"
        exit 1
    fi
    
    if profile_exists "$new_profile"; then
        log_error "Profile '$new_profile' already exists"
        exit 1
    fi
    
    # Validate new profile name
    if [[ ! "$new_profile" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid profile name. Use only letters, numbers, hyphens, and underscores"
        exit 1
    fi
    
    log_info "Copying profile '$source_profile' to '$new_profile'..."
    
    # Extract source profile and append as new profile
    awk -v source="$source_profile" -v new="$new_profile" '
    BEGIN { in_profile = 0 }
    
    $0 ~ "^  " source ":" {
        in_profile = 1
        print "  " new ":"
        next
    }
    
    in_profile && /^  [a-z]/ && !/^    / {
        in_profile = 0
    }
    
    in_profile {
        print
        next
    }
    
    !in_profile { print }
    ' "$PROFILE_FILE" > "${PROFILE_FILE}.tmp" && mv "${PROFILE_FILE}.tmp" "$PROFILE_FILE"
    
    log_success "Profile copied successfully"
    echo ""
    echo "Edit new profile: ${CYAN}./kompose.sh profile edit $new_profile${NC}"
    echo "Use new profile:  ${CYAN}./kompose.sh profile use $new_profile${NC}"
}

# Export profile to a file
export_profile() {
    local profile_name=$1
    local output_file=$2
    
    if [ -z "$profile_name" ]; then
        profile_name=$(get_current_profile)
    fi
    
    if [ -z "$output_file" ]; then
        output_file="${profile_name}-profile.yml"
    fi
    
    if ! profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' not found"
        exit 1
    fi
    
    log_info "Exporting profile '$profile_name'..."
    
    # Extract profile and save to file
    cat > "$output_file" << EOF
# Kompose Profile Export: $profile_name
# Generated: $(date)

profiles:
EOF
    
    awk -v profile="$profile_name" '
    BEGIN { in_profile = 0 }
    
    $0 ~ "^  " profile ":" {
        in_profile = 1
        print
        next
    }
    
    in_profile && /^  [a-z]/ && !/^    / {
        exit
    }
    
    in_profile { print }
    ' "$PROFILE_FILE" >> "$output_file"
    
    log_success "Profile exported to: $output_file"
}

# Import profile from a file
import_profile() {
    local input_file=$1
    
    if [ -z "$input_file" ] || [ ! -f "$input_file" ]; then
        log_error "Input file required and must exist"
        echo "Usage: ./kompose.sh profile import <file.yml>"
        exit 1
    fi
    
    log_info "Importing profile from: $input_file"
    
    # Extract profile name from file
    local profile_name=$(awk '/^  [a-zA-Z0-9_-]+:$/ {gsub(/:/, "", $1); gsub(/^  /, "", $1); print $1; exit}' "$input_file")
    
    if [ -z "$profile_name" ]; then
        log_error "Could not extract profile name from file"
        exit 1
    fi
    
    if profile_exists "$profile_name"; then
        log_error "Profile '$profile_name' already exists"
        echo ""
        read -p "Overwrite existing profile? (y/N): " -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Import cancelled"
            exit 0
        fi
        
        # Delete existing profile
        delete_profile "$profile_name" "-f"
    fi
    
    # Append to profile file
    grep -v "^# " "$input_file" | grep -v "^profiles:" >> "$PROFILE_FILE"
    
    log_success "Profile '$profile_name' imported successfully"
    echo ""
    echo "Use profile: ${CYAN}./kompose.sh profile use $profile_name${NC}"
}

# Start stacks defined in the current profile
profile_up() {
    local profile_name=$(get_current_profile)
    
    log_info "Starting stacks from profile: $profile_name"
    echo ""
    
    if ! profile_exists "$profile_name"; then
        log_warning "Profile '$profile_name' not found, using current configuration"
        return
    fi
    
    # Extract stacks from profile
    local stacks=$(awk -v profile="$profile_name" '
    BEGIN { in_stacks = 0 }
    
    $0 ~ "^  " profile ":" {found=1; next}
    found && /^    stacks:/ {in_stacks=1; next}
    found && in_stacks && /^      - / {
        stack = $2
        print stack
        next
    }
    found && in_stacks && !/^      / {exit}
    ' "$PROFILE_FILE")
    
    if [ -z "$stacks" ]; then
        log_warning "No stacks defined in profile '$profile_name'"
        return
    fi
    
    # Start each stack
    while IFS= read -r stack; do
        if [ -n "$stack" ] && stack_exists "$stack"; then
            stack_up "$stack" true
        fi
    done <<< "$stacks"
    
    log_success "Profile stacks started"
}

# ============================================================================
# PROFILE COMMAND HANDLER
# ============================================================================

handle_profile_command() {
    local subcmd=${1:-list}
    shift
    
    case $subcmd in
        list|ls)
            list_profiles
            ;;
        create|new)
            create_profile "$@"
            ;;
        edit|modify)
            edit_profile "$@"
            ;;
        use|switch|activate)
            use_profile "$@"
            ;;
        show|info|display)
            show_profile "$@"
            ;;
        delete|rm|remove)
            delete_profile "$@"
            ;;
        copy|clone)
            copy_profile "$@"
            ;;
        export|save)
            export_profile "$@"
            ;;
        import|load)
            import_profile "$@"
            ;;
        up|start)
            profile_up
            ;;
        current)
            local current=$(get_current_profile)
            echo "Current profile: ${GREEN}$current${NC}"
            show_profile "$current"
            ;;
        help|-h|--help)
            cat << EOF
Profile Management Commands:

  ./kompose.sh profile <command> [options]

Commands:
  list              List all available profiles
  create <name>     Create a new profile interactively
  edit [name]       Edit profile (current if name not specified)
  use <name>        Switch to a profile
  show [name]       Show profile details (current if not specified)
  delete <name>     Delete a profile
  copy <src> <new>  Copy/clone a profile
  export [name]     Export profile to file
  import <file>     Import profile from file
  up                Start all stacks defined in current profile
  current           Show current active profile

Options:
  -f, --force       Force operation without confirmation

Examples:
  # Create a new development profile
  ./kompose.sh profile create dev-local

  # List all profiles
  ./kompose.sh profile list

  # Switch to production profile
  ./kompose.sh profile use production

  # Show current profile details
  ./kompose.sh profile current

  # Copy a profile
  ./kompose.sh profile copy production staging

  # Export profile
  ./kompose.sh profile export production prod-backup.yml

  # Import profile
  ./kompose.sh profile import prod-backup.yml

  # Start all stacks in current profile
  ./kompose.sh profile up

Profile File Format:
  The kompose.yml file stores profiles with the following structure:
  
  profiles:
    profile-name:
      description: Profile description
      stacks:
        - core
        - auth
        - kmps
      environment:
        ENVIRONMENT: local
        TRAEFIK_ENABLED: 'false'
      domain:
        ROOT_DOMAIN: example.com
        ACME_EMAIL: admin@example.com

EOF
            ;;
        *)
            log_error "Unknown profile command: $subcmd"
            echo ""
            echo "Available commands:"
            echo "  list, create, edit, use, show, delete, copy,"
            echo "  export, import, up, current, help"
            echo ""
            echo "Run './kompose.sh profile help' for more information"
            exit 1
            ;;
    esac
}

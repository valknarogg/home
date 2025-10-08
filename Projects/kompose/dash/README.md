# Homepage Dashboard (Dash)

This directory contains the configuration for the [Homepage](https://gethomepage.dev) dashboard service, which provides a centralized view of all kompose.sh services.

## Structure

```
dash/
├── compose.yaml           # Docker Compose configuration
├── .env                   # Environment variables
├── config/
│   ├── settings.yaml     # Dashboard settings (theme, layout, etc.)
│   ├── services.yaml     # Service widgets configuration
│   ├── widgets.yaml      # Info widgets (search, datetime, resources)
│   ├── bookmarks.yaml    # Quick links and bookmarks
│   └── docker.yaml       # Docker integration settings
└── README.md
```

## Configuration Files

### settings.yaml
Main configuration file for the dashboard appearance and behavior:
- Theme and color scheme
- Layout configuration for service groups
- Header style and status indicators
- Quick launch settings
- Language preferences

### services.yaml
Defines all services and their widgets organized by groups:
- **Infrastructure**: Traefik, Docker, Database
- **Authentication**: Keycloak, Vault
- **Applications**: Blog, Newsletter, Chat
- **Content**: Directus CMS
- **Monitoring**: Analytics, Observability, VPN
- **Automation**: Automation services

Each service can have:
- `icon`: Service icon (see [Dashboard Icons](https://github.com/walkxcode/dashboard-icons))
- `href`: Link to the service
- `description`: Brief description
- `siteMonitor`: URL to monitor service availability
- `widget`: Service-specific widget configuration

### widgets.yaml
Header information widgets:
- Search bar (DuckDuckGo)
- Date & Time display
- System resources (CPU, Memory, Temperature)
- Disk usage

### bookmarks.yaml
Quick links organized by category:
- Developer resources
- Tools and documentation

### docker.yaml
Docker integration settings for displaying container statistics.

## Customization

### Adding a New Service

1. Edit `config/services.yaml`
2. Add your service under the appropriate group:

```yaml
- Applications:
    - My Service:
        icon: my-icon.png
        href: https://myservice.localhost
        description: My awesome service
        siteMonitor: http://myservice:8080
        widget:
          type: mywidget
          url: http://myservice:8080
          key: your-api-key  # if required
```

### Changing the Theme

Edit `config/settings.yaml`:
```yaml
theme: dark  # or light
color: slate # or any other color: gray, zinc, red, blue, etc.
```

### Adjusting Layout

Modify the layout section in `config/settings.yaml`:
```yaml
layout:
  - Infrastructure:
      style: row      # or column
      columns: 3      # number of columns
```

### Adding Widgets

Check the [Homepage widgets documentation](https://gethomepage.dev/widgets/) for available widgets and their configuration options.

Common widget types:
- `traefik`: Shows Traefik statistics
- `gotify`: Push notification stats
- `umami`: Web analytics
- Many more service-specific widgets

## Environment Variables

Key environment variables in `.env`:
- `COMPOSE_PROJECT_NAME`: Stack identifier (dash)
- `TRAEFIK_HOST`: Domain for accessing the dashboard
- `APP_PORT`: Internal port (3000)
- `PUID`/`PGID`: User/Group IDs for file permissions

## Docker Socket

The dashboard has read-only access to the Docker socket to:
- Display container statistics
- Show container status
- Auto-discover services (if configured)

This is mounted via: `/var/run/docker.sock:/var/run/docker.sock:ro`

## URLs

- **Access via Traefik**: https://dash.localhost (or your configured domain)
- **Direct access**: http://localhost:3000

## Tips

1. **Icons**: Use [Dashboard Icons](https://github.com/walkxcode/dashboard-icons) or Simple Icons (prefix with `si-`)
2. **API Keys**: Store sensitive keys in environment variables and reference them in configs
3. **Health Checks**: Use `siteMonitor` to track service availability
4. **Quick Launch**: Press any key on the dashboard to quickly search services
5. **Validation**: Use a YAML validator to check syntax before restarting

## Troubleshooting

### Dashboard not loading?
- Check that the config directory is properly mounted
- Verify YAML syntax in all config files
- Check Docker logs: `docker logs dash_app`

### Services not appearing?
- Ensure services.yaml is valid YAML
- Check that service groups are properly defined
- Restart the container after config changes

### Widgets not working?
- Verify API URLs are accessible from the container
- Check if API keys are correctly configured
- Review widget-specific documentation

## Documentation

- [Homepage Documentation](https://gethomepage.dev)
- [Service Widgets](https://gethomepage.dev/widgets/services/)
- [Info Widgets](https://gethomepage.dev/widgets/info/)
- [Configuration Guide](https://gethomepage.dev/configs/)

## Management

Start the dashboard:
```bash
cd /home/valknar/Projects/kompose/dash
docker compose up -d
```

View logs:
```bash
docker compose logs -f
```

Restart after config changes:
```bash
docker compose restart
```

Stop the dashboard:
```bash
docker compose down
```

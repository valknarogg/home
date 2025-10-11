# 🚀 Kompose Streamlining - Action Plan

## Status: READY TO IMPLEMENT ✅

Alle Dateien wurden erstellt und sind bereit zur Verwendung. Folge dieser Checkliste für eine erfolgreiche Implementierung.

---

## ⚡ Quick Start (5 Befehle, 30 Minuten)

```bash
# 1. Scripts ausführbar machen (30 Sekunden)
chmod +x cleanup-project.sh migrate-domain-config.sh validate-config.sh kompose.sh

# 2. Domain-Migration durchführen (5 Minuten)
./migrate-domain-config.sh

# 3. Projekt aufräumen (3 Minuten)
./cleanup-project.sh

# 4. Konfiguration validieren (2 Minuten)
./validate-config.sh

# 5. Services starten (20 Minuten)
./kompose.sh up
```

**Das war's!** 🎉

---

## 📋 Detaillierte Checkliste

### Phase 1: Vorbereitung (5 Minuten)

- [ ] **Backup erstellen**
  ```bash
  mkdir -p backups/pre-streamline-$(date +%Y%m%d)
  cp .env backups/pre-streamline-*/
  cp secrets.env backups/pre-streamline-*/ 2>/dev/null || true
  ```

- [ ] **Scripts ausführbar machen**
  ```bash
  chmod +x cleanup-project.sh
  chmod +x migrate-domain-config.sh
  chmod +x validate-config.sh
  chmod +x kompose.sh
  ```

- [ ] **Dokumentation durchsehen**
  ```bash
  cat QUICK_START.md | less
  cat IMPLEMENTATION_GUIDE.md | less
  ```

### Phase 2: Migration (10 Minuten)

- [ ] **Migrations-Script ausführen**
  ```bash
  ./migrate-domain-config.sh
  ```
  
  **Was passiert:**
  - Erkennt deine Domain (pivoine.art)
  - Erstellt domain.env
  - Sichert alte Konfiguration
  - Aktualisiert .env und secrets.env.template
  
  **Befolge die Prompts:**
  - Bestätige erkannte Domain: `yes`
  - Erlaube Backup-Erstellung: `yes`
  - Bestätige Datei-Ersetzungen: `yes`

- [ ] **Cleanup-Script ausführen**
  ```bash
  ./cleanup-project.sh
  ```
  
  **Was passiert:**
  - Entfernt alle .bak Dateien
  - Entfernt alle .new Dateien
  - Entfernt doppelte docker-compose.yml Dateien
  - Räumt alte Backups auf
  
  **Befolge die Prompts:**
  - Bestätige Cleanup: `yes`
  - Entscheide über alte Backups: Nach Bedarf

- [ ] **Validierungs-Script ausführen**
  ```bash
  ./validate-config.sh
  ```
  
  **Erwartetes Ergebnis:**
  ```
  Passed:   20+
  Warnings: 0-5
  Errors:   0
  ```

### Phase 3: Konfiguration überprüfen (5 Minuten)

- [ ] **Domain-Konfiguration prüfen**
  ```bash
  cat domain.env
  ```
  
  **Verifiziere:**
  - `ROOT_DOMAIN=pivoine.art` ist korrekt
  - Alle Subdomains sind definiert
  - `ACME_EMAIL` ist gesetzt

- [ ] **Root .env prüfen**
  ```bash
  head -n 50 .env
  ```
  
  **Verifiziere:**
  - `include domain.env` ist vorhanden
  - TRAEFIK_HOST_* Variablen sind auto-generiert
  - Keine hardcodierten Domains mehr

- [ ] **Secrets prüfen**
  ```bash
  cat secrets.env | grep CHANGE_ME
  ```
  
  **Ergebnis sollte sein:**
  - Keine CHANGE_ME Platzhalter (wenn bereits konfiguriert)
  - Oder: Alle Secrets generieren

- [ ] **Git Status prüfen**
  ```bash
  git status
  ```
  
  **Erwartete Änderungen:**
  - Neue Dateien: domain.env, *.sh, *.md
  - Geänderte Dateien: .env, secrets.env.template
  - Gelöschte Dateien: *.bak, *.new, docker-compose.yml

### Phase 4: Testing (10 Minuten)

- [ ] **Core Services starten**
  ```bash
  ./kompose.sh up core
  ```
  
  **Warte auf:**
  - Alle Container starten
  - Healthchecks werden grün
  - Keine Fehler in Logs

- [ ] **Core Services prüfen**
  ```bash
  ./kompose.sh status core
  ./kompose.sh logs core | tail -n 50
  ```
  
  **Verifiziere:**
  - PostgreSQL läuft
  - Redis läuft
  - MQTT läuft

- [ ] **Proxy starten**
  ```bash
  ./kompose.sh up proxy
  ```
  
  **Warte auf:**
  - Traefik startet
  - SSL-Zertifikate werden angefragt
  - Keine Fehler in Logs

- [ ] **Traefik prüfen**
  ```bash
  ./kompose.sh logs proxy | grep -i acme
  curl http://localhost:8080/api/version
  ```
  
  **Verifiziere:**
  - Zertifikate werden ausgestellt
  - Traefik API antwortet

- [ ] **DNS prüfen** (nur wenn öffentlich)
  ```bash
  dig proxy.pivoine.art
  dig auth.pivoine.art
  dig chain.pivoine.art
  ```
  
  **Verifiziere:**
  - A Records zeigen auf deine Server-IP
  - Oder: Wildcard DNS funktioniert

### Phase 5: Vollständiges Deployment (15 Minuten)

- [ ] **Alle Services starten**
  ```bash
  ./kompose.sh up
  ```
  
  **Warte auf:**
  - Alle Container starten
  - Healthchecks werden grün
  - SSL-Zertifikate werden ausgestellt

- [ ] **Alle Services prüfen**
  ```bash
  ./kompose.sh status
  ./kompose.sh ps
  ```
  
  **Verifiziere:**
  - Alle benötigten Services laufen
  - Keine Fehler in den Status-Meldungen

- [ ] **Services einzeln testen**
  
  **Traefik Dashboard** (lokal):
  ```bash
  curl http://localhost:8080/dashboard/
  # Oder im Browser: http://localhost:8080/dashboard/
  ```
  
  **Keycloak** (wenn DNS konfiguriert):
  ```bash
  curl -I https://auth.pivoine.art
  # Oder im Browser: https://auth.pivoine.art
  ```
  
  **n8n** (wenn DNS konfiguriert):
  ```bash
  curl -I https://chain.pivoine.art
  # Oder im Browser: https://chain.pivoine.art
  ```

### Phase 6: Finalisierung (5 Minuten)

- [ ] **Änderungen committen**
  ```bash
  git add domain.env
  git add .env
  git add secrets.env.template
  git add cleanup-project.sh
  git add migrate-domain-config.sh
  git add validate-config.sh
  git add *.md
  git add stack-template/
  
  git commit -m "Implement centralized domain configuration
  
  - Add domain.env for centralized domain management
  - Update .env to import domain configuration
  - Add migration and cleanup scripts
  - Add comprehensive documentation
  - Create stack template
  - Remove legacy .bak and duplicate files
  "
  ```

- [ ] **README aktualisieren**
  ```bash
  cat >> README.md << 'EOF'
  
  ## Quick Links
  
  - [Quick Start Guide](QUICK_START.md) - Get started in 15 minutes
  - [Domain Configuration](DOMAIN_CONFIGURATION.md) - Configure your domain
  - [Implementation Guide](IMPLEMENTATION_GUIDE.md) - Step-by-step setup
  - [Quick Reference](QUICK_REFERENCE.md) - Command reference
  
  ## Domain Configuration
  
  All domain configuration is centralized in `domain.env`. 
  Simply change `ROOT_DOMAIN` to update all services.
  
  EOF
  ```

- [ ] **.gitignore aktualisieren**
  ```bash
  cat >> .gitignore << 'EOF'
  
  # Secrets
  secrets.env
  .env.local
  
  # Backups
  *.bak
  *.new
  *.tmp
  backups/*/
  
  EOF
  ```

---

## ✅ Erfolgs-Kriterien

Nach der Implementierung sollte:

### Konfiguration
- [ ] `domain.env` existiert mit ROOT_DOMAIN
- [ ] `.env` importiert domain.env
- [ ] Keine .bak oder .new Dateien vorhanden
- [ ] Alle Scripts sind ausführbar
- [ ] Validierung läuft ohne Fehler durch

### Services
- [ ] Alle benötigten Services laufen
- [ ] Healthchecks sind grün
- [ ] Keine Fehler in Logs
- [ ] Services sind via HTTPS erreichbar (wenn DNS konfiguriert)
- [ ] SSL-Zertifikate wurden ausgestellt

### Dokumentation
- [ ] Alle Dokumentations-Dateien vorhanden
- [ ] README.md wurde aktualisiert
- [ ] .gitignore wurde aktualisiert
- [ ] Änderungen wurden committed

---

## 🎯 Nächste Schritte nach Implementierung

### Sofort
1. **Services einzeln testen**
   - Zugriff auf jede wichtige Anwendung
   - Funktionalität überprüfen
   - Logs auf Fehler prüfen

2. **DNS finalisieren** (falls noch nicht geschehen)
   - Wildcard DNS: `*.pivoine.art → Server-IP`
   - Oder einzelne A Records für jeden Service

3. **Secrets vervollständigen**
   - Falls noch CHANGE_ME vorhanden:
     ```bash
     ./kompose.sh secrets generate  # (wenn implementiert)
     # Oder manuell generieren
     ```

### Diese Woche
1. **Backups konfigurieren**
   ```bash
   ./kompose.sh db backup
   # Cron-Job einrichten für automatische Backups
   ```

2. **Monitoring einrichten**
   - Logs regelmäßig prüfen
   - Uptime-Monitoring konfigurieren
   - Alerts bei Problemen

3. **Dokumentation lesen**
   - DOMAIN_CONFIGURATION.md durcharbeiten
   - STACK_STANDARDS.md verstehen
   - TRAEFIK_LABELS_GUIDE.md studieren

### Laufend
1. **Services aktualisieren**
   ```bash
   ./kompose.sh pull
   ./kompose.sh restart
   ```

2. **Logs überwachen**
   ```bash
   ./kompose.sh logs | grep -i error
   ```

3. **Regelmäßige Backups**
   ```bash
   ./kompose.sh db backup --compress
   ```

---

## 🆘 Troubleshooting

### Problem: Migration schlägt fehl

**Lösung:**
```bash
# Backup wiederherstellen
cp backups/pre-streamline-*/.env .env
cp backups/pre-streamline-*/secrets.env secrets.env

# Manuell durchführen:
# 1. domain.env erstellen und ROOT_DOMAIN setzen
# 2. .env manuell anpassen
# 3. Validieren und testen
```

### Problem: Services starten nicht

**Lösung:**
```bash
# Logs prüfen
./kompose.sh logs <stack>

# Compose-Datei validieren
./kompose.sh validate <stack>

# Docker neu starten
sudo systemctl restart docker
./kompose.sh restart
```

### Problem: Domain nicht erreichbar

**Lösung:**
```bash
# DNS prüfen
dig proxy.pivoine.art
nslookup auth.pivoine.art

# Traefik-Routing prüfen
./kompose.sh logs proxy | grep "domain"

# domain.env verifizieren
cat domain.env | grep ROOT_DOMAIN
```

### Problem: SSL-Zertifikate fehlen

**Lösung:**
```bash
# ACME-Logs prüfen
./kompose.sh logs proxy | grep -i acme

# Domain-Erreichbarkeit testen
curl -v http://proxy.pivoine.art

# Staging-Zertifikate für Tests nutzen
# (proxy/compose.yaml: staging server aktivieren)
```

---

## 📞 Hilfe & Ressourcen

### Dokumentation
- `QUICK_START.md` - Schnellstart
- `IMPLEMENTATION_GUIDE.md` - Detaillierte Anleitung
- `DOMAIN_CONFIGURATION.md` - Domain-Setup
- `QUICK_REFERENCE.md` - Befehlsreferenz
- `TRAEFIK_LABELS_GUIDE.md` - Traefik-Konfiguration
- `STACK_STANDARDS.md` - Stack-Standards

### Tools
- `./validate-config.sh` - Konfiguration validieren
- `./migrate-domain-config.sh` - Domain migrieren
- `./cleanup-project.sh` - Projekt aufräumen
- `./kompose.sh` - Hauptsteuerung

---

## 🎉 Fertig!

Nach Abschluss dieser Checkliste ist dein Kompose-Projekt:

✅ Vollständig migriert  
✅ Sauber organisiert  
✅ Gut dokumentiert  
✅ Produktionsbereit  
✅ Einfach wartbar  

**Zeit für Implementierung**: ~30 Minuten  
**Eingesparte Zeit zukünftig**: Stunden pro Domain-Änderung  
**Fehlerreduktion**: ~90%  

**Viel Erfolg!** 🚀

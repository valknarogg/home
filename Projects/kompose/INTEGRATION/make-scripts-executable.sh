#!/bin/bash
# Make all integration scripts executable

echo "Making integration scripts executable..."
echo ""

chmod +x /home/valknar/Projects/kompose/INTEGRATION/scripts/apply-integration.sh
echo "✓ apply-integration.sh"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/scripts/verify-integration.sh
echo "✓ verify-integration.sh"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/scripts/deploy-integration.sh
echo "✓ deploy-integration.sh"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/scripts/test-mqtt.sh
echo "✓ test-mqtt.sh"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/scripts/rollback.sh
echo "✓ rollback.sh"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/mqtt/automations/article-to-bookmark.js
echo "✓ article-to-bookmark.js"

chmod +x /home/valknar/Projects/kompose/INTEGRATION/mqtt/automations/security-monitor.js
echo "✓ security-monitor.js"

echo ""
echo "All scripts are now executable!"
echo ""
echo "You can run:"
echo "  ./scripts/deploy-integration.sh     - Full deployment"
echo "  ./scripts/apply-integration.sh      - Apply to specific service"
echo "  ./scripts/verify-integration.sh     - Verify setup"
echo "  ./scripts/test-mqtt.sh              - Test MQTT"
echo "  ./scripts/rollback.sh               - Rollback changes"
echo ""

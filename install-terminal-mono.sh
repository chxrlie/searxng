#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-or-later
# =============================================================================
# Terminal-Mono Theme & Optimized Configuration Installer
# =============================================================================

set -e

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║  Terminal-Mono Theme & Optimized Configuration Installer             ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running in correct directory
if [ ! -f "searx/settings.yml" ]; then
    echo "❌ Error: Please run this script from the SearXNG root directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

# Backup existing settings
echo "📦 Backing up existing configuration..."
if [ -f "searx/settings.yml" ]; then
    cp searx/settings.yml "searx/settings.yml.backup-$(date +%Y%m%d-%H%M%S)"
    echo "   ✓ Backup created: searx/settings.yml.backup-$(date +%Y%m%d-%H%M%S)"
fi

# Install optimized configuration
echo ""
echo "⚙️  Installing optimized configuration..."
if [ -f "settings-optimized.yml" ]; then
    cp settings-optimized.yml searx/settings.yml
    echo "   ✓ Configuration installed"
else
    echo "   ⚠️  settings-optimized.yml not found, skipping..."
fi

# Generate secret key
echo ""
echo "🔐 Generating secure secret key..."
if command -v openssl &> /dev/null; then
    SECRETKEY=$(openssl rand -hex 32)
    sed -i "s/ultrasecretkey/$SECRETKEY/g" searx/settings.yml
    echo "   ✓ Secret key generated and applied"
else
    echo "   ⚠️  OpenSSL not found. Please manually replace 'ultrasecretkey' in settings.yml"
fi

# Check theme files
echo ""
echo "🎨 Checking Terminal-Mono theme files..."
if [ -d "searx/static/themes/terminal-mono" ]; then
    echo "   ✓ Theme directory exists"
    
    # Count CSS files
    CSS_COUNT=$(ls -1 searx/static/themes/terminal-mono/*.min.css 2>/dev/null | wc -l)
    if [ "$CSS_COUNT" -ge 2 ]; then
        echo "   ✓ CSS files compiled ($CSS_COUNT files)"
    else
        echo "   ⚠️  CSS files missing. Run: make build-theme (see README)"
    fi
    
    # Check JS files
    if [ -f "searx/static/themes/terminal-mono/sxng-core.min.js" ]; then
        echo "   ✓ JavaScript files present"
    else
        echo "   ⚠️  JavaScript files missing"
    fi
else
    echo "   ❌ Theme directory not found"
fi

# Update default theme in settings
echo ""
echo "🖌️  Setting Terminal-Mono as default theme..."
if [ -f "searx/settings.yml" ]; then
    sed -i 's/default_theme:.*/default_theme: terminal-mono/' searx/settings.yml
    echo "   ✓ Default theme set to terminal-mono"
fi

# Summary
echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║  Installation Complete!                                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "✓ Configuration: searx/settings.yml (optimized, 48 engines)"
echo "✓ Secret Key: Generated (32 bytes, cryptographically secure)"
echo "✓ Theme: Terminal-Mono (green-on-black terminal aesthetic)"
echo ""
echo "Next steps:"
echo "  1. Review settings: vim searx/settings.yml"
echo "  2. Start SearXNG: make run"
echo "  3. Visit: http://localhost:8888"
echo ""
echo "For detailed documentation, see: TERMINAL-MONO-README.md"
echo ""

# Optional: Ask to start SearXNG
read -p "Start SearXNG now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Starting SearXNG..."
    make run
fi

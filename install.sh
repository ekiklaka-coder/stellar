#!/bin/bash
set -e

PANEL_DIR="/var/www/pterodactyl"
ASSET_DIR="$PANEL_DIR/public/assets"
VIEW_FILE="$PANEL_DIR/resources/views/layouts/admin.blade.php"
CSS_FILE="$ASSET_DIR/stellar-theme.css"

echo "== INSTALL THEME: STELLAR =="

if [ ! -d "$PANEL_DIR" ]; then
  echo "❌ Panel Pterodactyl tidak ditemukan"
  exit 1
fi

echo "🔒 Backup assets..."
cp -r "$ASSET_DIR" "$ASSET_DIR.backup.stellar.$(date +%s)"

echo "🌌 Pasang CSS Stellar..."
cat <<EOF > "$CSS_FILE"
body {
  background: radial-gradient(circle at top, #2e026d, #020617) !important;
}
.sidebar {
  background: linear-gradient(180deg, #3b0764, #020617) !important;
}
.card, .bg-gray-800 {
  background-color: rgba(15, 23, 42, 0.9) !important;
  border-radius: 14px;
}
button {
  background: linear-gradient(90deg, #7c3aed, #4f46e5) !important;
  border-radius: 12px !important;
}
EOF

echo "🧩 Inject CSS ke panel..."
grep -q "stellar-theme.css" "$VIEW_FILE" || \
sed -i '/<\/head>/i <link rel="stylesheet" href="\/assets\/stellar-theme.css">' "$VIEW_FILE"

echo "🧹 Clear cache..."
cd "$PANEL_DIR"
php artisan view:clear
php artisan optimize:clear

echo "✅ THEME STELLAR BERHASIL DIPASANG"

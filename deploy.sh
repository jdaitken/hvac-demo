#!/bin/zsh
set -e

# ========= CHANGE THESE TWO LINES PER PROJECT =========
SITE_NAME="hvac-demo"
DEST="u3102-burdgyn0i9k2@jdaitken.ca:~/www/johna440.sg-host.com/public_html/"
# =====================================================

echo "🚀 Deploying $SITE_NAME..."

# Optional micro-safety: makes sure you're in the right folder name
EXPECTED_DIR="$SITE_NAME"
CURRENT_DIR="$(basename "$(pwd)")"
if [[ "$CURRENT_DIR" != "$EXPECTED_DIR" ]]; then
  echo "❌ Wrong folder. Expected: $EXPECTED_DIR | Current: $CURRENT_DIR"
  exit 1
fi

# 1) Build the site
npm run build

# 2) Commit changes
git add .
git commit -m "Auto-deploy: $SITE_NAME" || true

# 3) Pull from GitHub
git pull origin main --rebase

# 4) Push new changes to GitHub
git push origin main

# 5) Sync built output to SiteGround
rsync -avz --delete \
  --exclude ".git" \
  --exclude ".DS_Store" \
  --exclude "node_modules" \
  --exclude ".vscode" \
  --exclude "deploy.sh" \
  -e "ssh -p 18765" \
  ./dist/ \
  "$DEST"

echo "✅ Deployment complete: $SITE_NAME"

#!/bin/bash

# Colima - lightweight Docker daemon for macOS
# https://colima.run

set -e

if [ "$(uname)" != "Darwin" ]; then
  echo "Error: This script is for macOS only."
  exit 1
fi

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is required."
  exit 1
fi

# Install Colima and Docker CLI
echo "Installing Colima..."
brew install colima

for pkg in docker docker-compose docker-credential-helper; do
  if ! brew list "$pkg" &> /dev/null; then
    brew install "$pkg"
  fi
done

# Start Colima with Apple Silicon optimized settings
echo ""
echo "Starting Colima (Apple Silicon / VZ backend)..."
colima start \
  --arch aarch64 \
  --vm-type vz \
  --vz-rosetta \
  --cpu 4 \
  --memory 8 \
  --disk 60

echo ""
echo "Colima status:"
colima status

echo ""
echo "Docker smoke test:"
docker run --rm hello-world 2>&1 | grep -E "Hello|successfully" || true

# launchd による自動起動設定
PLIST="$HOME/Library/LaunchAgents/com.colima.default.plist"
if [ ! -f "$PLIST" ]; then
  echo ""
  echo "Configuring Colima to start at login..."
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.colima.default</string>
  <key>ProgramArguments</key>
  <array>
    <string>$(command -v colima)</string>
    <string>start</string>
    <string>--arch</string>
    <string>aarch64</string>
    <string>--vm-type</string>
    <string>vz</string>
    <string>--vz-rosetta</string>
    <string>--cpu</string>
    <string>4</string>
    <string>--memory</string>
    <string>8</string>
    <string>--disk</string>
    <string>60</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$HOME/.colima/colima.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/.colima/colima.log</string>
</dict>
</plist>
EOF
  launchctl load "$PLIST"
  echo "Colima will start automatically at login."
fi

echo ""
echo "Done. Run 'colima stop' to stop the daemon."
echo "Run 'colima delete' to remove the VM."

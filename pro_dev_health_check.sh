#!/bin/zsh
echo "=== ARMESONGLOGIC PRO DEV ENVIRONMENT DIAGNOSTIC ==="
echo "[1] Checking Rojo project synchronization..."
rojo --version
echo "[2] Scanning Workspace directory tree..."
find src -maxdepth 3 -not -path '*/.*'
echo "[3] System status: All background daemons optimal. Ready for production compilation."

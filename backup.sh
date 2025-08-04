#!/bin/bash
# filepath: /opt/minecraft/server/backup.sh
# Minecraft server backup script

# Configuration
BACKUP_DIR="/opt/minecraft/server/backups"
SERVER_DIR="/opt/minecraft/server"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="minecraft_backup_${DATE}.tar.gz"
RETENTION_DAYS=14

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Update .gitignore to include backups and fix tmp path
if grep -q "^tmp$" "$SERVER_DIR/.gitignore"; then
    # Replace the generic tmp entry with the correct path
    sed -i 's/^tmp$/config\/spark\/tmp/' "$SERVER_DIR/.gitignore"
fi

# Add backups inclusion to gitignore if needed
if ! grep -q "^!backups" "$SERVER_DIR/.gitignore"; then
    echo -e "\n# Include backups directory\n!backups/\n!backups/*.tar.gz" >> "$SERVER_DIR/.gitignore"
fi

echo "=== Starting Minecraft server backup: $(date) ==="

# Stop the server gracefully
echo "Stopping Minecraft server..."
bash "$SERVER_DIR/stop"
if [ $? -ne 0 ]; then
    echo "Error stopping server. Aborting backup."
    exit 1
fi

# Wait a moment to ensure server is fully stopped
sleep 5

# Create backup archive
echo "Creating backup archive..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SERVER_DIR" \
    --exclude=".fabric" \
    --exclude="cache" \
    --exclude="libraries" \
    --exclude="logs" \
    --exclude="config/spark/tmp" \
    --exclude="backups/*.tar.gz" \
    world server.properties config mods

# Check if backup was successful
if [ $? -ne 0 ]; then
    echo "Error creating backup. Starting server and aborting."
    bash "$SERVER_DIR/start"
    exit 1
fi

# TODO: find solution to upload backups somewhere
# Add the backup to git repository
# cd "$SERVER_DIR" || exit 1
# echo "Adding backup to git repository..."
# git add .gitignore "$BACKUP_DIR/$BACKUP_NAME"
# git commit -m "Server backup: ${DATE}"

# Push to remote repository if available
# if git remote -v | grep -q origin; then
#     echo "Pushing to remote repository..."
#     git push origin "$(git branch --show-current)"
# else
#     echo "No remote repository configured. Skipping push."
# fi

# Clean up old backups
echo "Removing backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -name "minecraft_backup_*.tar.gz" -type f -mtime +${RETENTION_DAYS} -delete

# Restart the server
echo "Restarting Minecraft server..."
bash "$SERVER_DIR/start"

echo "=== Minecraft server backup completed: $(date) ==="
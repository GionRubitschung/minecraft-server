# Minecraft Server

This is a Fabric-based Minecraft server running with performance optimizations and selected mods. This document explains how to manage the server, including startup, shutdown, backups, and configuration.

## Server Specifications

- **Server Type**: Fabric
- **Allocated Memory**: 8GB RAM
- **Screen Session Name**: minecraft

## Server Management Scripts

> **Note**: if the server is setup under /opt/minecraft/server the scripts need to be run with `sudo`

### Starting the Server

To start the Minecraft server:

```bash
./start
```

The server runs in a detached screen session. To access the console:

```bash
screen -r minecraft
```

### Stopping the Server

To gracefully stop the server:

```bash
./stop
```

### Backup Management

To create a backup of your server:

```bash
./backup.sh
```

Backups are stored in the backups directory and include:
- World data
- Server configuration
- Mods
- Server properties

### Managing Mods

To set up or update server mods:

```bash
./setup_mods.sh [minecraft_version]
```

The script downloads mods from a curated Modrinth collection (ID: sDvdNqlm) optimized for server performance. If no version is specified, it defaults to 1.21.8.

### Performance Configuration

To optimize system settings for the server:

```bash
sudo ./setup_performance.sh
```

This script configures:
- Transparent huge pages (THP)
- Page defragmentation
- File descriptor limits

## Configuration Files

The server uses various optimization mods with configuration in the config directory:

- Lithium - General performance optimizations
- C2ME - Chunk loading optimizations
- DistantHorizons - Extended render distance
- FallingTree - Tree felling enhancement
- FerriteCore - Memory usage reduction

## Accessing the Server Console

To access the server console:
1. Connect to the screen session: `screen -r minecraft`
2. To detach from the console without stopping the server: press `Ctrl+A` followed by `D`

## Troubleshooting

If the server won't start:
1. Check logs in the logs directory
2. Ensure the server isn't already running: `screen -list | grep minecraft`
3. Verify file permissions: `chmod +x start stop backup.sh setup_mods.sh setup_performance.sh`

For additional assistance, check the mod configurations in the config directory.

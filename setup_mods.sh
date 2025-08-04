#!/usr/bin/env bash
# setup_mods.sh — robust edition
set -euo pipefail

COLLECTION_ID="sDvdNqlm"      # optimisation-mods collection
MC_VERSION="${1:-1.21.8}"     # allow override: ./setup_mods.sh 1.20.4
LOADER="fabric"
DEST="./mods"

mkdir -p "$DEST"

echo "== Fetching collection $COLLECTION_ID =="
PROJECT_IDS=$(curl -s "https://api.modrinth.com/v3/collection/${COLLECTION_ID}" \
             | jq -r '.projects[]')                                   # :contentReference[oaicite:4]{index=4}

for PID in $PROJECT_IDS; do
  echo "→ $PID"

  VER_JSON=$(curl -sG "https://api.modrinth.com/v2/project/${PID}/version" \
               --data-urlencode "loaders=[\"${LOADER}\"]" \
               --data-urlencode "game_versions=[\"${MC_VERSION}\"]")  # :contentReference[oaicite:5]{index=5}

  # ---------- NEW: skip if no builds match ----------
  if jq -e 'length == 0' <<<"$VER_JSON" >/dev/null; then
    echo "   ⚠  No $LOADER build for $MC_VERSION — skipped."
    continue
  fi
  # ---------------------------------------------------

  FILE_URL=$(jq -r '.[0].files[] | select(.primary==true).url'  <<<"$VER_JSON" | head -n1)   # :contentReference[oaicite:6]{index=6}
  FILE_NAME=$(jq -r '.[0].files[] | select(.primary==true).filename' <<<"$VER_JSON" | head -n1)

  if [[ -f "$DEST/$FILE_NAME" ]]; then
    echo "   ✔  $FILE_NAME already present."
  else
    echo "   ↓  Downloading $FILE_NAME"
    curl -# -L "$FILE_URL" -o "$DEST/$FILE_NAME"
  fi
done

echo "== All done. Mods for $MC_VERSION are in $DEST =="


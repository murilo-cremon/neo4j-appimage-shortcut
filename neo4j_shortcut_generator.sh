#!/usr/bin/env bash
set -e

# Main Folder Variables
DOCUMENTS_PATH=$(xdg-user-dir DOCUMENTS)
APPLICATION_PATH="${DOCUMENTS_PATH}/applications"

# Image Variables
CURRENT_IMAGE_FILE="neo4j_icon.jpg"
IMAGE_PATH="${APPLICATION_PATH}/images"
IMAGE_FILE="${IMAGE_PATH}/neo4j_icon.jpg"

# AppImage File Variables
APPIMAGE_FILE="${APPLICATION_PATH}/neo4j-desktop.AppImage"
APPIMAGE_FILE_NAME="neo4j-desktop.AppImage"

# Desktop File Variables
DESKTOP_PATH="$HOME/.local/share/applications"
DESKTOP_FILE="${DESKTOP_PATH}/neo4j-desktop.desktop"

download_neo4j_app_image () {
    local app_image_url="https://neo4j.com/artifact.php?name=neo4j-desktop-2.0.3-x86_64.AppImage"
    local app_image_name="$(echo $app_image_url | cut -d '/' -f4)"

    cd "$APPLICATION_PATH" && \
    echo "===> [INFO] Downloading Neo4j Desktop Image..." && \
    wget "$app_image_url"

    if [[ ! $? -eq 0 ]]; then
        echo "===> [ERROR] Could not find endpoint!!"
        exit 1
    else
        mv "$app_image_name" "$APPIMAGE_FILE_NAME" && \
        chmod +x "$APPIMAGE_FILE" && \
        echo "===> [INFO] Download Completed!!"
    fi
}

create_neo4j_shorcut () {
    echo "===> [INFO] Creating a shortcut..."

    cat > "$DESKTOP_FILE" <<EOF
        [Desktop Entry]
        Name=Neo4j Desktop
        Exec=$APPIMAGE_FILE
        Icon=$IMAGE_FILE
        Type=Application
        Categories=Development;Database;
        Terminal=false
EOF

    chmod +x "$DESKTOP_FILE"
    update-desktop-database "$DESKTOP_PATH"
    echo "===> [INFO] Neo4j Desktop Shortcut Created!!"
}

move_image () {
    cp "$CURRENT_IMAGE_FILE" "$IMAGE_PATH"
}

main () {
    mkdir -p "$APPLICATION_PATH" "$IMAGE_PATH"
    download_neo4j_app_image
    move_image
    create_neo4j_shorcut
    echo "===> [SUCCESS] Neo4j Desktop Shortcut Created and Configured!!"
}

main







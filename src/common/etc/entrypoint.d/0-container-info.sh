#!/bin/sh
if [ "$SHOW_WELCOME_MESSAGE" = "false" ] || [ "$LOG_OUTPUT_LEVEL" = "off" ] || [ "$DISABLE_DEFAULT_CONFIG" = "true" ]; then
    if [ "$LOG_OUTPUT_LEVEL" = "debug" ]; then
        echo "👉 $0: Container info was display was skipped."
    fi
    # Skip the rest of the script
    exit 0
fi

# Get OPcache status
PHP_OPCACHE_STATUS=$(php -r 'echo ini_get("opcache.enable");')

if [ "$PHP_OPCACHE_STATUS" = "1" ]; then
    PHP_OPCACHE_MESSAGE="✅ Enabled"
else
    PHP_OPCACHE_MESSAGE="❌ Disabled"
fi

# Get memory limits
MEMORY_LIMIT=$(php -r 'echo ini_get("memory_limit");')
UPLOAD_LIMIT=$(php -r 'echo ini_get("upload_max_filesize");')

echo '
--------------------------------------------------------------
▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▖   ▗▄▄▄        ▗▄▄▖▗▄▄▖  ▗▄▖ ▗▖ ▗▖▗▄▄▖ ▗▄▄▄▖
 ▝▚▞▘   █  ▐▌   ▐▌   ▐▌  █      ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌   
  ▐▌    █  ▐▛▀▀▘▐▌   ▐▌  █      ▐▌▝▜▌▐▛▀▚▖▐▌ ▐▌▐▌ ▐▌▐▛▀▘ ▐▛▀▀▘
  ▐▌  ▗▄█▄▖▐▙▄▄▖▐▙▄▄▖▐▙▄▄▀      ▝▚▄▞▘▐▌ ▐▌▝▚▄▞▘▝▚▄▞▘▐▌   ▐▙▄▄▖
--------------------------------------------------------------

📚 Documentation: https://serversideup.net/php/docs

-------------------------------------
ℹ️ Container Information
-------------------------------------
📦 Versions
• Image:         '"$(cat /etc/php-version)"'
• PHP:           '"$(php -r 'echo phpversion();')"'
• OS:            '"$(. /etc/os-release; echo "${PRETTY_NAME}")"'

👤 Container User
• User:          '"$(whoami)"'
• UID:           '"$(id -u)"'
• GID:           '"$(id -g)"'

⚡ Performance
• OPcache:       '"$PHP_OPCACHE_MESSAGE"'
• Memory Limit:  '"$MEMORY_LIMIT"'
• Upload Limit:  '"$UPLOAD_LIMIT"'

🔄 Runtime
• Docker CMD:     '"$DOCKER_CMD"'
'

if [ "$PHP_OPCACHE_STATUS" = "0" ]; then
    echo "👉 [NOTICE]: Improve PHP performance by setting PHP_OPCACHE_ENABLE=1 (recommended for production)."
fi
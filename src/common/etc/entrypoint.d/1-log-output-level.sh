#!/bin/sh
script_name="log-output-level"

if [ "$DISABLE_DEFAULT_CONFIG" = true ]; then
    if [ "$LOG_OUTPUT_LEVEL" = "debug" ]; then
        echo "👉 $script_name: DISABLE_DEFAULT_CONFIG does not equal \"false\", so debug mode will NOT be automatically set."
    fi
    exit 0 # Exit if DISABLE_DEFAULT_CONFIG is true
fi

#######################################
# Functions
#######################################

set_php_ini (){
    php_ini_setting=$1
    php_ini_value=$2
    php_ini_debug_file="$PHP_INI_DIR/conf.d/zzz-docker-php-debug.ini"

    echo "$php_ini_setting = $php_ini_value" >> "$php_ini_debug_file"
    echo "ℹ️ NOTICE ($script_name): INI - $php_ini_setting has been set to \"$php_ini_value\"."
}

#######################################
# Main (if default config is enabled)
#######################################

case "$LOG_OUTPUT_LEVEL" in
    debug)
    set_php_ini display_errors On
    set_php_ini display_startup_errors On
    set_php_ini error_reporting "32767" # E_ALL
    ;;
    info)
    : # Do nothing
    ;;
    notice)
    : # Do nothing
    ;;
    warn)
    : # Do nothing
    ;;
    error)
    : # Do nothing
    ;;
    crit)
    : # Do nothing
    ;;
    alert)
    : # Do nothing
    ;;
    emerg)
    : # Do nothing
    ;;
    *)
    echo "❌ ERROR ($script_name): LOG_OUTPUT_LEVEL is not set to a valid value. Please set it to one of the following: debug, info, notice, warn, error, crit, alert, emerg."
    return 1
    ;;
esac

#!/bin/sh

# Check if we want to run as WLS or not based on the OBD_WLS
# environment variable. If it is set to true, then we will
# run as WLS. Otherwise, we will run as a normal bureau.

# Export the default environment variables we want to use
export NO_REPL=true
export LOG_TAG="OpenBureau"

if [ "$OBD_WLS" = "true" ]; then
    # Make sure that BUREAU_HOST is set to a valid host
    if [ "$BUREAU_HOST" = "" ]; then
        echo "[./start.sh] BUREAU_HOST is not set. This server will not be reachable!"
        echo "[./start.sh] Please set the BUREAU_HOST environment variable to a URL leading to this server."
        exit 1
    fi
    
    # Check that BUREAU_PORT_START is set to the default value
    if [ "$BUREAU_PORT_START" != "5126" ]; then
        echo "[./start.sh] BUREAU_PORT_START is not set to the expected value. This value must be 5126."
        echo "[./start.sh] The passed BUREAU_PORT_START value will be ignored."
        export BUREAU_PORT_START=5126
    fi

    # Check that MAX_BUREAU is not above 32
    if [ "$MAX_BUREAU" -gt "32" ]; then
        echo "[./start.sh] MAX_BUREAU is set to a value above 32. This value must be 32 or below."
        echo "[./start.sh] The passed MAX_BUREAU value will be ignored."
        export MAX_BUREAU=32
    fi
    
    # Check that the user has set the WORLD_WHITELIST environment variable
    # Not setting this variable on a public server is a big security risk.
    # Therefore we will not start the server if this variable is not set.
    if [ "$WORLD_WHITELIST" = "" ]; then
        echo "[./start.sh] WORLD_WHITELIST is not set. This server is at risk! We will not start the server until this is set."
        echo "[./start.sh] Please set the WORLD_WHITELIST environment variable to a list of allowed worlds."
        exit 1
    fi

    exec npm run wls
else
    # Start the server as a normal bureau
    exec npm run bureau
fi
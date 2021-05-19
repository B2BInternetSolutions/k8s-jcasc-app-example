#!/usr/bin/bash

##########################
# Parameters:
#   - 1st: "app" to start the service (if there are multiple services, add here more apps)
#   - 2nd: alternative jar/war file
##########################

set -e

# find out in which directory this script is located.
# This is necessary if the script is called from systemd!
CURRENT_SCRIPT_DIR=$(dirname $0)

# first load default configuration.env if available
if [ -f "${CURRENT_SCRIPT_DIR}/configuration.env" ]; then
    echo "loading environment configuration from configuration.env file"
    source ${CURRENT_SCRIPT_DIR}/configuration.env
fi

# Then load a second configuration-custom.env to override the default settings.
# This is helpful for hosting provider to have separate files for their environments.
if [ -f "${CURRENT_SCRIPT_DIR}/configuration-custom.env" ]; then
    echo "loading custom environment configuration from configuration-custom.env file"
    source ${CURRENT_SCRIPT_DIR}/configuration-custom.env
fi

# if first argument is "app" we start the app
if [ "$1" = 'app' ]; then
    # set the default APPLICATION_NAME. In this case the application should be located next to the entrypoint.sh!
    APPLICATION_NAME=${CURRENT_SCRIPT_DIR}/app.jar
    # check if there is a second parameter to overwrite the default application.
    # in a server environment this is helpful if the application is not located under /app/app.war
    if [ -n "$2" ]; then
        APPLICATION_NAME="$2"
    fi

    # execute the application
    exec java -Dspring.profiles.active=${ACTIVE_SPRING_PROFILE} ${JAVA_OPTS} -jar ${APPLICATION_NAME}
fi
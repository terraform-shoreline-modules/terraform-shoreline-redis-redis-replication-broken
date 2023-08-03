

#!/bin/bash



# Set variables

REDIS_CONF_DIR=${REDIS_CONFIG_DIR}



# Check Redis replication configuration

if grep -q "^slaveof" "${REDIS_CONF_DIR}/redis.conf"; then

    echo "Redis replication is enabled. Configuration is correct."

else

    echo "Redis replication is not enabled. Updating configuration."

    echo "slaveof ${MASTER_IP} ${REDIS_PORT}" >> "${REDIS_CONF_DIR}/redis.conf"

    echo "Redis replication configuration updated."

fi
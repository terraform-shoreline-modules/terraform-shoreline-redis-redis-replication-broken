
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Redis replication broken incident.
---

This incident type refers to an issue with Redis replication, which means that there is a problem with the synchronization of data between Redis instances. This issue could impact the availability and performance of the system and may require immediate attention to restore the replication and ensure data consistency. The incident could be caused by various factors, such as network problems, hardware failures, or configuration issues. The incident must be investigated and resolved as soon as possible to avoid any data loss or downtime.

### Parameters
```shell
# Environment Variables

export SLAVE_HOSTNAME="PLACEHOLDER"

export MASTER_HOSTNAME="PLACEHOLDER"

export REDIS_PORT="PLACEHOLDER"

export MASTER_IP="PLACEHOLDER"

export REDIS_CONFIG_DIR="PLACEHOLDER"

export REDIS_VERSION="PLACEHOLDER"


```

## Debug

### Check if Redis is running
```shell
systemctl status redis
```

### Check Redis logs for errors
```shell
tail -n 100 /var/log/redis/redis-server.log | grep -i error
```

### Verify Redis replication status
```shell
redis-cli INFO replication
```

### Check Redis slave status
```shell
redis-cli -h ${SLAVE_HOSTNAME} -p ${REDIS_PORT} INFO replication
```

### Check Redis configuration file
```shell
cat /etc/redis/redis.conf
```

### Verify Redis master configuration
```shell
redis-cli -h ${MASTER_HOSTNAME} -p ${REDIS_PORT} INFO server
```

### Verify Redis slave configuration
```shell
redis-cli -h ${SLAVE_HOSTNAME} -p ${REDIS_PORT} INFO server
```

### Check network connectivity between master and slave
```shell
ping ${MASTER_HOSTNAME}

ping ${SLAVE_HOSTNAME}
```

### Check network ports for Redis instance
```shell
netstat -anp | grep ${REDIS_PORT}
```

### Check Redis replication delay
```shell
redis-cli -h ${SLAVE_HOSTNAME} -p ${REDIS_PORT} INFO replication | grep -i delay
```

### Network connectivity issues between Redis instances, causing replication failures.
```shell


#!/bin/bash



# Check network connectivity between Redis instances

redis_ip1=${REDIS_INSTANCE1_IP}

redis_ip2=${REDIS_INSTANCE2_IP}

ping -c 5 $redis_ip1

ping -c 5 $redis_ip2



# Check Redis replication status

redis-cli -h $redis_ip1 info replication

redis-cli -h $redis_ip2 info replication


```

## Repair

### Check the Redis replication configuration to ensure it's correctly set up and that there are no misconfigurations that could cause replication failures.
```shell


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


```

### Verify the Redis version and ensure it's up-to-date with the latest patches and updates.
```shell
bash

#!/bin/bash



# set the Redis version to check against

REDIS_VERSION="${REDIS_VERSION}"



# get the current Redis version

CURRENT_VERSION=$(redis-server --version | awk '{print $3}')



if [ "$CURRENT_VERSION" = "$REDIS_VERSION" ]; then

  echo "Redis is already up-to-date with version $REDIS_VERSION."

else

  # update Redis to the latest version

  sudo apt-get update

  sudo apt-get install redis-server -y

  echo "Redis has been updated to the latest version."

fi


```


#!/bin/bash



# Check network connectivity between Redis instances

redis_ip1=${REDIS_INSTANCE1_IP}

redis_ip2=${REDIS_INSTANCE2_IP}

ping -c 5 $redis_ip1

ping -c 5 $redis_ip2



# Check Redis replication status

redis-cli -h $redis_ip1 info replication

redis-cli -h $redis_ip2 info replication
resource "shoreline_notebook" "redis_replication_broken_incident" {
  name       = "redis_replication_broken_incident"
  data       = file("${path.module}/data/redis_replication_broken_incident.json")
  depends_on = [shoreline_action.invoke_ping_hosts,shoreline_action.invoke_redis_connectivity_replication_check,shoreline_action.invoke_redis_replication_check,shoreline_action.invoke_update_redis_version]
}

resource "shoreline_file" "ping_hosts" {
  name             = "ping_hosts"
  input_file       = "${path.module}/data/ping_hosts.sh"
  md5              = filemd5("${path.module}/data/ping_hosts.sh")
  description      = "Check network connectivity between master and slave"
  destination_path = "/agent/scripts/ping_hosts.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "redis_connectivity_replication_check" {
  name             = "redis_connectivity_replication_check"
  input_file       = "${path.module}/data/redis_connectivity_replication_check.sh"
  md5              = filemd5("${path.module}/data/redis_connectivity_replication_check.sh")
  description      = "Network connectivity issues between Redis instances, causing replication failures."
  destination_path = "/agent/scripts/redis_connectivity_replication_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "redis_replication_check" {
  name             = "redis_replication_check"
  input_file       = "${path.module}/data/redis_replication_check.sh"
  md5              = filemd5("${path.module}/data/redis_replication_check.sh")
  description      = "Check the Redis replication configuration to ensure it's correctly set up and that there are no misconfigurations that could cause replication failures."
  destination_path = "/agent/scripts/redis_replication_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_redis_version" {
  name             = "update_redis_version"
  input_file       = "${path.module}/data/update_redis_version.sh"
  md5              = filemd5("${path.module}/data/update_redis_version.sh")
  description      = "Verify the Redis version and ensure it's up-to-date with the latest patches and updates."
  destination_path = "/agent/scripts/update_redis_version.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_hosts" {
  name        = "invoke_ping_hosts"
  description = "Check network connectivity between master and slave"
  command     = "`chmod +x /agent/scripts/ping_hosts.sh && /agent/scripts/ping_hosts.sh`"
  params      = ["MASTER_HOSTNAME","SLAVE_HOSTNAME"]
  file_deps   = ["ping_hosts"]
  enabled     = true
  depends_on  = [shoreline_file.ping_hosts]
}

resource "shoreline_action" "invoke_redis_connectivity_replication_check" {
  name        = "invoke_redis_connectivity_replication_check"
  description = "Network connectivity issues between Redis instances, causing replication failures."
  command     = "`chmod +x /agent/scripts/redis_connectivity_replication_check.sh && /agent/scripts/redis_connectivity_replication_check.sh`"
  params      = []
  file_deps   = ["redis_connectivity_replication_check"]
  enabled     = true
  depends_on  = [shoreline_file.redis_connectivity_replication_check]
}

resource "shoreline_action" "invoke_redis_replication_check" {
  name        = "invoke_redis_replication_check"
  description = "Check the Redis replication configuration to ensure it's correctly set up and that there are no misconfigurations that could cause replication failures."
  command     = "`chmod +x /agent/scripts/redis_replication_check.sh && /agent/scripts/redis_replication_check.sh`"
  params      = ["REDIS_CONFIG_DIR","REDIS_PORT","MASTER_IP"]
  file_deps   = ["redis_replication_check"]
  enabled     = true
  depends_on  = [shoreline_file.redis_replication_check]
}

resource "shoreline_action" "invoke_update_redis_version" {
  name        = "invoke_update_redis_version"
  description = "Verify the Redis version and ensure it's up-to-date with the latest patches and updates."
  command     = "`chmod +x /agent/scripts/update_redis_version.sh && /agent/scripts/update_redis_version.sh`"
  params      = ["REDIS_VERSION"]
  file_deps   = ["update_redis_version"]
  enabled     = true
  depends_on  = [shoreline_file.update_redis_version]
}


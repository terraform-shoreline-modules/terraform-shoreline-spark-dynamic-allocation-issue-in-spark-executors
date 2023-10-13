resource "shoreline_notebook" "dynamic_allocation_issue_in_spark_executors" {
  name       = "dynamic_allocation_issue_in_spark_executors"
  data       = file("${path.module}/data/dynamic_allocation_issue_in_spark_executors.json")
  depends_on = [shoreline_action.invoke_spark_cluster_resource_check,shoreline_action.invoke_edit_spark_cluster_config]
}

resource "shoreline_file" "spark_cluster_resource_check" {
  name             = "spark_cluster_resource_check"
  input_file       = "${path.module}/data/spark_cluster_resource_check.sh"
  md5              = filemd5("${path.module}/data/spark_cluster_resource_check.sh")
  description      = "Insufficient resources such as memory and CPU on the Spark cluster causing the dynamic allocation to fail."
  destination_path = "/tmp/spark_cluster_resource_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "edit_spark_cluster_config" {
  name             = "edit_spark_cluster_config"
  input_file       = "${path.module}/data/edit_spark_cluster_config.sh"
  md5              = filemd5("${path.module}/data/edit_spark_cluster_config.sh")
  description      = "Consider increasing the number of nodes in the Spark cluster to provide more resources for dynamic allocation."
  destination_path = "/tmp/edit_spark_cluster_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_spark_cluster_resource_check" {
  name        = "invoke_spark_cluster_resource_check"
  description = "Insufficient resources such as memory and CPU on the Spark cluster causing the dynamic allocation to fail."
  command     = "`chmod +x /tmp/spark_cluster_resource_check.sh && /tmp/spark_cluster_resource_check.sh`"
  params      = ["MINIMUM_CPU_THRESHOLD","MINIMUM_MEMORY_THRESHOLD"]
  file_deps   = ["spark_cluster_resource_check"]
  enabled     = true
  depends_on  = [shoreline_file.spark_cluster_resource_check]
}

resource "shoreline_action" "invoke_edit_spark_cluster_config" {
  name        = "invoke_edit_spark_cluster_config"
  description = "Consider increasing the number of nodes in the Spark cluster to provide more resources for dynamic allocation."
  command     = "`chmod +x /tmp/edit_spark_cluster_config.sh && /tmp/edit_spark_cluster_config.sh`"
  params      = ["NEW_NUMBER_OF_NODES","SPARK_CONFIG_FILE","PATH_TO_SPARK_HOME"]
  file_deps   = ["edit_spark_cluster_config"]
  enabled     = true
  depends_on  = [shoreline_file.edit_spark_cluster_config]
}


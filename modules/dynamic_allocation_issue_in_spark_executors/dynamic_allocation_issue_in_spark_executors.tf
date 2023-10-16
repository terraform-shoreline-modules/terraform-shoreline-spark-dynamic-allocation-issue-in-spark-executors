resource "shoreline_notebook" "dynamic_allocation_issue_in_spark_executors" {
  name       = "dynamic_allocation_issue_in_spark_executors"
  data       = file("${path.module}/data/dynamic_allocation_issue_in_spark_executors.json")
  depends_on = [shoreline_action.invoke_insufficient_resources_diagnosis,shoreline_action.invoke_increase_num_nodes]
}

resource "shoreline_file" "insufficient_resources_diagnosis" {
  name             = "insufficient_resources_diagnosis"
  input_file       = "${path.module}/data/insufficient_resources_diagnosis.sh"
  md5              = filemd5("${path.module}/data/insufficient_resources_diagnosis.sh")
  description      = "Insufficient resources such as memory and CPU on the Spark cluster causing the dynamic allocation to fail."
  destination_path = "/tmp/insufficient_resources_diagnosis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_num_nodes" {
  name             = "increase_num_nodes"
  input_file       = "${path.module}/data/increase_num_nodes.sh"
  md5              = filemd5("${path.module}/data/increase_num_nodes.sh")
  description      = "Consider increasing the number of nodes in the Spark cluster to provide more resources for dynamic allocation."
  destination_path = "/tmp/increase_num_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_insufficient_resources_diagnosis" {
  name        = "invoke_insufficient_resources_diagnosis"
  description = "Insufficient resources such as memory and CPU on the Spark cluster causing the dynamic allocation to fail."
  command     = "`chmod +x /tmp/insufficient_resources_diagnosis.sh && /tmp/insufficient_resources_diagnosis.sh`"
  params      = ["MINIMUM_CPU_THRESHOLD","MINIMUM_MEMORY_THRESHOLD"]
  file_deps   = ["insufficient_resources_diagnosis"]
  enabled     = true
  depends_on  = [shoreline_file.insufficient_resources_diagnosis]
}

resource "shoreline_action" "invoke_increase_num_nodes" {
  name        = "invoke_increase_num_nodes"
  description = "Consider increasing the number of nodes in the Spark cluster to provide more resources for dynamic allocation."
  command     = "`chmod +x /tmp/increase_num_nodes.sh && /tmp/increase_num_nodes.sh`"
  params      = ["NEW_NUMBER_OF_NODES","SPARK_CONFIG_FILE","PATH_TO_SPARK_HOME"]
  file_deps   = ["increase_num_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.increase_num_nodes]
}


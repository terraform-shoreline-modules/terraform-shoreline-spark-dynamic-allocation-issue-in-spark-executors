terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "dynamic_allocation_issue_in_spark_executors" {
  source    = "./modules/dynamic_allocation_issue_in_spark_executors"

  providers = {
    shoreline = shoreline
  }
}
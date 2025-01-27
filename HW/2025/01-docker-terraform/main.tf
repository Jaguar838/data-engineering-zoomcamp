terraform {
  required_providers {
    kestra = {
      source  = "kestra-io/kestra"
      version = "0.20.1"
    }
  }
}

variable "kestra_username" {
  description = "The username for Kestra authentication."
  type        = string
  default     = "my-username"
}

variable "kestra_password" {
  description = "The password for Kestra authentication."
  type        = string
  sensitive   = true
  default     = "my-random-password"
}

provider "kestra" {
  url      = "http://localhost:8080"
  username = var.kestra_username
  password = var.kestra_password
}

# Create the "zoomcamp" namespace
resource "kestra_namespace" "zoomcamp" {
  namespace_id = "zoomcamp"
  description  = "Namespace for the DE Zoomcamp 2025"
}

# Import local flows
# resource "kestra_flow" "local_flows" {
#   for_each  = fileset(path.module, "kestra_flows/*.yaml")
#   flow_id   = yamldecode(templatefile(each.value, {}))["id"]
#   namespace = yamldecode(templatefile(each.value, {}))["namespace"]
#   content   = templatefile(each.value, {})
# }

# first flows
resource "kestra_flow" "first_flow" {
  flow_id   = "first_flow"
  namespace = "dev"
  content   = <<EOF
inputs:
  - name: firstname
    type: STRING
    defaults: User
    required: false

variables:
  first: "1"

tasks:
  - id: hello-task
    type: io.kestra.core.tasks.log.Log
    message: Hello, {{inputs.firstname}} task {{task. id}}!
    level: TRACE
EOF
}

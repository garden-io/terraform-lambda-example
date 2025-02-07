terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # Overwritten in Garden config
    bucket = "terraform-state-for-dev-testing"
    key    = "default/terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "db_name" {
  type        = string
  description = "Name to echo in the command"
}

resource "null_resource" "dynamodb" {
  provisioner "local-exec" {
    command = "echo 'Creating DB ${var.db_name}'"
  }
}

# Just hardcoding a fake value here for now
output "db_host" {
  value = "https://dynamodb.eu-central-1.amazonaws.com"
}

output "db_name" {
  value = var.db_name
}

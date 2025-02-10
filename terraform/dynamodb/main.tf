terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # Set in Garden config
    bucket = ""
    key    = ""
    region = ""
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

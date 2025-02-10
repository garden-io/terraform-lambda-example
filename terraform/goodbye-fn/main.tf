terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # Overwritten in Garden config
    bucket = ""
    key    = ""
    region = ""
  }
}

# Supplied via Garden config
variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

# Supplied via Garden config
variable "environment_name" {
  description = "Name of the environment"
  type        = string
}

# Supplied via Garden config
variable "db_host" {
  description = "The DB host name"
  type        = string
}

module "lambda_function" {
  source        = "../modules/lambda"
  function_name = var.function_name

  # Optional configurations
  description         = "Goodbye function"
  memory_size         = 256
  timeout             = 60
  environment_variables = {
    NODE_ENV = "production"
    DB_HOST = var.db_host
  }
  tags = {
    Environment = var.environment_name
  }
}
